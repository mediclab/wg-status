/* application.vala
 *
 * Copyright 2022 Dmitriy Kozhanov
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

using Gtk;
using Gee;
using AppIndicator;

namespace WgStatus {
    public class Application : Gtk.Application {
        private Indicator systemIndicator;
        private Gtk.Menu appMenu;
        private WgStatus.NMcli NMcli;

        public Application () {
            Object (
                application_id: "org.mediclab.wgstatus",
                flags: ApplicationFlags.FLAGS_NONE
            );

            this.NMcli = new WgStatus.NMcli();
            this.appMenu = this.createIndicatorMenu();
            this.systemIndicator = this.createSystemIndicator();
            this.systemIndicator.set_menu(this.appMenu);
        }
        
        private Indicator createSystemIndicator() {
            var systemIndicator = new Indicator(
                "wgstatustest",
                "org.mediclab.wgstatus",
                IndicatorCategory.APPLICATION_STATUS
            );
            
            systemIndicator.set_status(IndicatorStatus.ACTIVE);
            
            return systemIndicator;
        }


        private Gtk.Menu createIndicatorMenu () {
            var appMenu = new Gtk.Menu();

            foreach (var con in this.NMcli.getWireguardConnections()) {
                var item = new Gtk.CheckMenuItem.with_label(con.key);

                item.set_active(this.NMcli.isConnectionActive(con.key));

                item.toggled.connect((i) => {
                    this.toggleConnection(i, i.get_label());
                });

                item.show();
                appMenu.append(item);
            }

            appMenu.append(new Gtk.SeparatorMenuItem());

            var aboutItem = new Gtk.MenuItem.with_label("About");

            aboutItem.activate.connect(() => {
                var about_dialog = new AboutDialog ();
                about_dialog.present ();
            });
            
            aboutItem.show();
            appMenu.append(aboutItem);
            appMenu.append(new Gtk.SeparatorMenuItem());

            var quitItem = new Gtk.MenuItem.with_label("Quit");

            quitItem.activate.connect(() => {
                Gtk.main_quit();
            });
            
            quitItem.show();
            appMenu.append(quitItem);
            
            return appMenu;
        }

        private void toggleConnection (Gtk.CheckMenuItem item, string name) {
            if (item.get_active()) {
                if (!this.NMcli.isConnectionActive(name) && this.NMcli.upConnection(name)) {
                    this.notify(name + " successfully activated");
                }

                return;
            }

            if (this.NMcli.isConnectionActive(name) && this.NMcli.downConnection(name)) {
                this.notify(name + " successfully deactivated");
            }
        }

        private void notify (string text) {
            Notify.Notification notification = new Notify.Notification (
                "WG-STATUS",
                text,
                "dialog-information"
            );

            try {
                notification.show();
            } catch (Error e) {
		        error ("Error: %s", e.message);
	        }
        }
    }
}
