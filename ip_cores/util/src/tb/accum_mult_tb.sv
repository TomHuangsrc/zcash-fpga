/*
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
`timescale 1ps/1ps

module accum_mult_tb ();
import common_pkg::*;

localparam CLK_PERIOD = 100;

logic clk, rst;

if_axi_stream #(.DAT_BYTS(66)) in_if(clk);
if_axi_stream #(.DAT_BYTS(66)) out_if(clk);

initial begin
  rst = 0;
  repeat(2) #(20*CLK_PERIOD) rst = ~rst;
end

initial begin
  clk = 0;
  forever #CLK_PERIOD clk = ~clk;
end

always_comb begin
  out_if.sop = 1;
  out_if.eop = 1;
  out_if.ctl = 0;
  out_if.mod = 0;
  out_if.err = 0;
end

// Check for errors
always_ff @ (posedge clk)
  if (out_if.val && out_if.err)
    $error(1, "%m %t ERROR: output .err asserted", $time);

accum_mult # (
  .BITS_A  ( 264 ),
  .LEVEL_A ( 4   ),
  .LEVEL_B ( 6   )
) 
accum_mult (
  .i_clk ( clk ),
  .i_rst ( rst ),
  .i_dat_a ( in_if.dat[0 +: 264]   ),
  .i_dat_b ( in_if.dat[264 +: 264] ),
  .i_val   ( in_if.val             ),
  .o_rdy ( in_if.rdy ),
  .o_dat ( out_if.dat ),
  .o_val ( out_if.val ),
  .i_rdy ( out_if.rdy )
);



task test_loop();
begin
  integer signed get_len;
  logic [common_pkg::MAX_SIM_BYTS*8-1:0] expected,  get_dat;
  logic [263:0] in_a, in_b;
  integer i, max;
  get_dat = 0;
  $display("Running test_loop...");
  i = 0;
  max = 10000;
  
  while (i < max) begin
    in_a = random_vector(264/8);
    in_b = random_vector(264/8);
    expected = (in_a * in_b);
    
    fork
      in_if.put_stream({in_b, in_a}, 528/8);
      out_if.get_stream(get_dat, get_len);
    join
    
    common_pkg::compare_and_print(get_dat, expected);
    $display("test_loop PASSED loop %d/%d", i, max);
    i = i + 1;
  end
  
  $display("test_loop PASSED");
end
endtask;

initial begin
  out_if.rdy = 0;
  in_if.val = 0;
  #(40*CLK_PERIOD);
  
  test_loop();

  #1us $finish();
end
endmodule