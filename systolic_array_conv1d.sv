`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/28/2025 07:34:55 PM
// Design Name: 
// Module Name: systolic_array_conv1d
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


module systolic_array_conv1d #(
    parameter int N = 3,
    parameter int XW = 8,
    parameter int YW = 32)(
    input logic signed [XW-1:0] x_in,
    input logic signed [XW-1:0] w [N],
    input logic signed [YW-1:0] y_in,
    input logic clk,
    output logic signed [YW-1:0] y_out
    );
    
    logic signed [XW-1:0] x_bus [N+1];
    logic signed [YW-1:0] y_bus [N+1];
    
    genvar i;
    generate
        for (i = 0; i < N; i++) begin: SL
            unit_slice #(
                .XW(XW), 
                .YW(YW)) 
                u (
                .clk(clk),
                .x_in (x_bus[i+1]),
                .x_out(x_bus[i]),
                .w    (w[i]),
                .y_in (y_bus[i]),
                .y_out(y_bus[i+1])
             );
        end
    endgenerate
    
    assign x_bus[N] = x_in;
    assign y_bus[0] = y_in;
    assign y_out = y_bus[N];
endmodule
