/* nmcli.vala
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

using Gee;

namespace WgStatus {
    public class NMcli {
        private NM.Client client;
        private HashMap<string, NM.Device> wgDevices;
        
        public NMcli() {
            this.client = new NM.Client();
            this.wgDevices = new HashMap<string, NM.Device>();
            
            this.client.get_all_devices().foreach ((dev) => {
                if (dev.get_type_description() == "wireguard") {
                    this.wgDevices.set(dev.get_iface(), dev);
                }
                
            });
        }
        
        public HashMap<string, NM.Connection> getWireguardConnections() {
            var wgConnections = new HashMap<string, NM.Connection>();
            
            foreach (var wgDevice in this.wgDevices) {
                foreach (var wgConnection in wgDevice.value.get_available_connections()) {
                    wgConnections.set(wgConnection.get_id(), wgConnection);
                }
            }
            
            return wgConnections;
        }
        
        public bool upConnection (string name) {
            foreach (var wgDevice in this.wgDevices) {
                foreach (var wgConnection in wgDevice.value.get_available_connections()) {
                    if (wgConnection.get_id() == name) {
                        this.client.activate_connection_async(
                            wgConnection,
                            wgDevice.value,
                            wgDevice.value.get_path(),
                            null
                        );
                        
                        return true;
                    }
                }
            }

            return false;
        }
        
        public bool downConnection(string name) {
            foreach (var wgDevice in this.wgDevices) {
                var wgConnection = wgDevice.value.get_active_connection();
                
                if (wgConnection.get_id() == name) {
                    this.client.deactivate_connection_async(wgConnection, null);
                    
                    return true;
                }
            }

            return false;
        }
        
        public bool isConnectionActive(string name) {
            foreach (var wgConnection in this.client.get_active_connections()) {
                if (wgConnection.get_id() == name) {
                    return true;
                }
            }

            return false;
        }
    }
}
