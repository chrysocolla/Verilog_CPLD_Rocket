module top(
    input           clk,        // CLK{@1MHz}       系统时钟
                    rst,        // BTN_0            复位信号
                    btn,        // BTN_7            开始信号
    output          BEEP,       // Buzzer           蜂鸣器
                    RS,         // LCD1602          数据/指令寄存器选择控制端
                    RW,         // LCD1602          读写信号控制端
                    E,          // LCD1602          使能端
    output  [7:0]   ROW,        // dot-matrix LED   行
                    COL_R,      // dot-matrix LED   列(红)
                    COL_G,      // dot-matrix LED   列(绿)
                    DISP_C_n,   // DISP             数码管片选
                    DISP_S,     // DISP             数码管段选
                    DB          // LCD1602          并行数据
);
///////////////////////////////////////////////////
    wire            clk_1, clk_2, clk_4, clk_8, clk_4000;
    wire    [3:0]   note;
    wire    [5:0]   seq;
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

endmodule // top
