module pulse_gen
# (
    parameter           N = 3,  // Number 个数 默认为3
    parameter   [5:0]   end_a,  // End_A 第一个状态末尾地址码
                        end_b   // End_B 第二个状态末尾地址码
) (
    input               clk_in, // input clock 输入时钟
                        rst,    // reset 复位信号
                        btn,    // button 开始计时信号
    input       [5:0]   seq,    // sequence 按秒记的序列地址
    output  reg [N-1:0] clk_outs// output clock 输出时钟
);
    always @(posedge clk_in or posedge rst)
        if (rst)                // 复位时将输出归零
            clk_outs        <=  1'b0;
        else if (seq == end_a || seq == end_b)
            if (btn)            // 开始计时时将输出归零
                clk_outs    <=  1'b0;
            else if (&clk_outs) // 到达计数尾部时停止计数
                clk_outs    <=  clk_outs;
            else                // 正常加1计数
                clk_outs    <=  clk_outs + 1'b1;
        else                    // 正常加1计数
            clk_outs        <=  clk_outs + 1'b1;
endmodule // pulse_gen
