`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2025 11:49:41 PM
// Design Name: 
// Module Name: unit_slice
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module unit_slice #(
    parameter int XW = 8, 
    parameter int YW = 32)(
    input logic signed [XW-1:0] x_in,
    input logic signed [XW-1:0] w,
    input logic signed [YW-1:0] y_in,
    input logic clk,
    output logic signed [XW-1:0] x_out,
    output logic signed [YW-1:0] y_out
    );

    always_ff @ (posedge clk)
    begin
        x_out <= x_in;
        y_out <= y_in + w*x_out;
    end        

endmodule
