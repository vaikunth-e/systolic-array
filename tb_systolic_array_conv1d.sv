`timescale 1ns / 1ps

module tb_systolic_array_conv1d;

    localparam int N  = 3;
    localparam int XW = 8;
    localparam int YW = 32;

    logic                    clk;
    logic signed [XW-1:0]    x_in;
    logic signed [XW-1:0]    w    [N];
    logic signed [YW-1:0]    y_in;
    logic signed [YW-1:0]    y_out;
    
    // streams
    logic signed [XW-1:0] stream1 [0:3];
    logic signed [XW-1:0] stream2 [0:3];

    // initialize the DUT (systolic array module) w/ params & signals
    systolic_array_conv1d #(
        .N (N),
        .XW(XW),
        .YW(YW)
    ) dut (
        .clk  (clk),
        .x_in (x_in),
        .w    (w),
        .y_in (y_in),
        .y_out(y_out)
    );

    // generate 100 MHz clock (clock with 10 ns period)
    initial clk = 1'b0;
    always  #5 clk = ~clk; // up 5 ns, down 5 ns -> 10 ns period

    // cycle counter for output
    int cycle;

    // task to apply one sample and log values
    task automatic apply_sample(
        input logic signed [XW-1:0] x_val,
        input logic signed [YW-1:0] yprev,
        input string fun_case_tag
    );
    begin
        x_in = x_val;
        y_in = yprev;
        @(posedge clk);
        #1;
        $display("(%0s) cycle=%0d  x_in=%0d  y_in=%0d  y_out=%0d",
            fun_case_tag, cycle, x_in, y_in, y_out);
        cycle++;
    end
    endtask

    // test case sequences
    initial begin
        cycle = 0;
        x_in  = '0;
        y_in  = '0;

        w[0] = 8'sd1;
        w[1] = -8'sd2;
        w[2] = 8'sd3;

        // streams for CASE 3
        stream1[0] =  8'sd1;
        stream1[1] =  8'sd2;
        stream1[2] =  8'sd3;
        stream1[3] =  8'sd4;

        stream2[0] = -8'sd1;
        stream2[1] = -8'sd2;
        stream2[2] = -8'sd3;
        stream2[3] = -8'sd4;

        // clean initial pipeline
        repeat (2) @(posedge clk);

        // CASE 1: Yprev = 0 (normal convolution)
        $display("\nCASE 1: Yprev = 0\n");

        apply_sample(8'sd5, 32'sd0, "C1");
        apply_sample(-8'sd3, 32'sd0, "C1");
        apply_sample(8'sd2, 32'sd0, "C1");
        apply_sample(8'sd1, 32'sd0, "C1");

        repeat (4) apply_sample(8'sd0, 32'sd0, "C1_FLUSH");

        // CASE 2: preload Yprev w/ values (signed check)
        $display("\nCASE 2: Yprev = +10\n");

        apply_sample(8'sd4, 32'sd10, "C2");
        apply_sample(-8'sd1, 32'sd10, "C2");
        apply_sample(8'sd3, 32'sd10, "C2");

        repeat (4) apply_sample(8'sd0, 32'sd10, "C2_FLUSH");

        // CASE 3: interleaved streams
        $display("\nCASE 3: Interleaved Streams\n");
        for (int i = 0; i < 4; i++) begin
            apply_sample(stream1[i], 32'sd0, "C3_S1");
            apply_sample(stream2[i], 32'sd0, "C3_S2"); 
        end

        repeat (6) apply_sample(8'sd0, 32'sd0, "C3_FLUSH");

        $display("\nall cases complete, ending simulation\n");
        $finish;
    end

endmodule

