# Copyright (C) 2018 Tsinghua University Corporation.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
# implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import os
import sys

def load_tt_flowtable(dirpath, host_id):
    schedule_path = os.path.join(dirpath, "tables")
    # adapter_path = os.path.join(dirpath, "adapter")
    flow_table = []
    for _, _, filenames in os.walk(schedule_path):
        for tbfile in filenames:
            host_str, etype_str = os.path.splitext(tbfile)[0].split('_')
            host_info, if_str = host_str.split(',')
            h_id = int(host_info[5:])
            if_id = int(if_str) + 1
            tb_path = os.path.join(schedule_path, tbfile)
            if etype_str == "send" and int(host_id) == h_id:
                with open(tb_path, 'r') as tb:
                    flow_num = int(tb.readline())
                    for i in range(flow_num):
                        entry = tb.readline()
                        schd_time, period, flow_id, buffer_id, \
                            flow_size = entry.split()
                        flow_table.append(if_id)
                        flow_table.append(int(flow_id))
                        flow_table.append(int(schd_time))
                        flow_table.append(int(period))
                        flow_table.append(int(buffer_id))
                        flow_table.append(int(flow_size))
        break
    return flow_table


if __name__ == '__main__':
    # table_path = "/home/chenwh/Workspace/Data/minimal"
    flow_table = load_tt_flowtable(sys.argv[1], sys.argv[2])
    for m in flow_table:
        print m

