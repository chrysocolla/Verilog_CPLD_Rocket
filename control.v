module control(
    input               clk_1,      // input clock@1Hz输入时钟1Hz
                        rst,        // reset BTN0 复位信号
                        btn,        // button BTN7 开始计时
    output  reg [5:0]   seq         // sequence 按秒记的序列地址
);

always @(negedge clk_1 or posedge rst)
    if (rst)
        seq <=  6'd0;           // 异步复位
    else if (btn && (seq == 6'd1 || seq == 6'd33))
        seq <=  6'd2;           // 同步置位
    else
        seq <=  seq + 6'd1;     // 正常加1计数
endmodule // control
