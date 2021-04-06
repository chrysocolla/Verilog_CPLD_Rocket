`timescale 100us / 10ns
module top_testbranch;
    parameter CLK_PERIOD = 10;

    reg clk;
    initial
        clk = 1'b0;
    always
        clk = #(CLK_PERIOD/2) ~clk;

    reg rst,btn;

    initial begin
        rst = 1'b0;
        btn = 1'b0;
        #10;
        rst = 1'b1;
        #10;
        rst = 1'b0;
        #21000000;
        btn = 1'b1;
        #10;
        btn = 1'b0;
    end
///////////////////////////////////////////////////
    wire            clk_1, clk_2, clk_4, clk_8, clk_4000,BEEP,RS,RW,E;
    wire    [3:0]   note;
    wire    [5:0]   seq;
    wire    [7:0]   ROW,COL_R,COL_G,DISP_C_n,DISP_S,DB;
    wire    [63:0]  col_r_data,
                    col_g_data;
///////////////////////////////////////////////////
    clk_gen_serial # (
        .N          (2),
        .mag        ({20'd249, 20'd124}),
        .wid        ({5'd8, 5'd7})
    ) clk_gen_packed (
        .clk        (clk),
        .rst        (rst),
        .clk_outs   ({clk_8, clk_4000})
    );

    pulse_gen # (
        .N          (3),
        .end_a      (6'd33),
        .end_b      (6'd1)
    ) pg (
        .clk_in     (clk_8),
        .rst        (rst),
        .btn        (btn),
        .seq        (seq),
        .clk_outs   ({clk_1, clk_2, clk_4})
    );

    control co (
        .clk_1  (clk_1),
        .rst    (rst),
        .btn    (btn),
        .seq    (seq)
    );
///////////////////////////////////////////////////
    data da (
        .pulse      ({clk_1, clk_2, clk_4}),
        .seq        (seq),
        .e          (E),
        .rs         (RS),
        .rw         (RW),
        .note       (note),
        .disp_c_n   (DISP_C_n),
        .disp_s     (DISP_S),
        .db         (DB),
        .col_r_data (col_r_data),
        .col_g_data (col_g_data)
    );
///////////////////////////////////////////////////
    dot88 dot (
        .clk_4000   (clk_4000),
        .rst        (rst),
        .col_r_data (col_r_data),
        .col_g_data (col_g_data),
        .row        (ROW),
        .col_r      (COL_R),
        .col_g      (COL_G)
    );

    music mu (
        .clk        (clk),
        .rst        (rst),
        .note       (note),
        .speaker    (BEEP)
    );

endmodule
