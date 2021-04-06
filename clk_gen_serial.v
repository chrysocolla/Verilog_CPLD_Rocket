module clk_gen_serial
# (
    parameter   N   = 1,            // Number           个数 默认为1
    parameter   [20*N-1:0]  mag,    // Magnification    倍数 以20位表示
    parameter   [5*N-1:0]   wid     // Bit width        位宽 以5 位表示
) (
    input           clk,            // Base clock@ 1MHz 系统时钟
                    rst,            // Reset signal     复位信号
    output  [N-1:0] clk_outs        // Out clocks       输出时钟
);
////////////////////////////////////////////////////////////////////////////////
    wire    [N:0]   mid_clk;        // Middle clk wires 中间连线
    reg     [N-1:0] cnt;            // Counters         计数器寄存器
    assign  mid_clk[0] = clk;       // clk_gen_even#clk 系统时钟作第一个模块输入
    assign  clk_outs = mid_clk[N:1];// clk_outs         高N位为输出时钟
////////////////////////////////////////////////////////////////////////////////
    genvar i;                                       // 用于模块例化的生成变量
    generate                                        // 生成块
        for (i = 0; i < N; i = i + 1) begin: SMCL   // 标签 用于标识不同模块
            clk_gen_even # (                        // 参数例化
                .mag    (mag[20*(i+1)-1:20*i]),     // 解析出幅度参数
                .wid    (wid[5*(i+1)-1:5*i])        // 解析出位宽参数
            ) cg_even (
                .clk    (mid_clk[i]),               // 输入时钟
                .rst    (rst),                      // 复位信号
                .clk_out(mid_clk[i+1])              // 输出时钟
            );
        end
    endgenerate
////////////////////////////////////////////////////////////////////////////////
endmodule // clk_gen_serial
