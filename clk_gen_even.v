module clk_gen_even
# (
    parameter   mag,    // Magnification/2-1  最大值 免去错误例化处理
    parameter   wid     // Bit width          寄存器位宽 手动优化资源
) (
    input       clk,    // Base clock@ 1MHz   系统时钟
                rst,    // Reset signal       复位信号
    output  reg clk_out // Out clock=base/mag 输出时钟=基频/倍数
);
////////////////////////////////////////////////////////////////////
    reg [wid-1:0]   cnt =   1'b0;   // init reg 初始化计数器寄存器
    always @(posedge clk or posedge rst)
        if (rst) begin
            cnt     <=  1'b0;       // reset 复位处理计数器寄存器
            clk_out <=  1'b0;       // reset 复位处理输出寄存器
        end else begin
            if (cnt == mag[wid-1:0]) begin
                cnt <=  1'b0;       // clear 计满时清零
                clk_out <= ~clk_out;// flip 翻转输出寄存器
            end else
                cnt <=  cnt +  1'b1;// add1 加1计数
        end
////////////////////////////////////////////////////////////////////
endmodule // clk_gen_even
