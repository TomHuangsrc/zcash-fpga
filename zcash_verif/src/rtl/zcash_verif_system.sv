/*
  This takes in an AXI stream of a block and runs verification
  checks (detailed in the architecture document). When all the checks are
  completed the o_val will go high, and o_mask bit mask will be 1 for any
  checks that failed.
  
  Copyright (C) 2019  Benjamin Devlin and Zcash Foundation

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */ 

module zcash_verif_system #(
)(
  input i_clk, i_rst,
  
  if_axi_stream.sink  i_axi,
  output logic [31:0] o_mask,
  output logic        o_val
);
  

endmodule