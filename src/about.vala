/* about.vala
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

namespace WgStatus {
    public class AboutDialog : Gtk.AboutDialog {   
        construct {
            this.set_destroy_with_parent (true);
          	this.set_modal (true);
            this.logo_icon_name = "org.mediclab.wgstatus";
          	this.authors = {"Med1c84 (Dmitriy Kozhanov) <medic8463@gmail.com>"};
          	this.program_name = "WG-STATUS";
          	this.copyright = "Copyright © 2022 Med1c84 (Dmitriy Kozhanov)";
          	this.version = "1.0";
          	this.license = "GPLv3.0+ (https://www.gnu.org/licenses/gpl-3.0.txt)";
          	this.wrap_license = true;
          	this.website = "https://typaknote.ru";
          	this.website_label = "Author blog";

            this.response.connect ((response_id) => {
          		if (response_id == Gtk.ResponseType.CANCEL || response_id == Gtk.ResponseType.DELETE_EVENT) {
          			   this.hide_on_delete ();
          		}
          	});
        }
    }
}
