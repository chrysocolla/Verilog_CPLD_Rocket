module dot88(
        input               clk_4000,
                            rst,
        input       [63:0]  col_r_data,
                            col_g_data,
        output  reg [7:0]   row,
                            col_r,
                            col_g
    );
////////////////////////////////////////////////////////////
    reg [2:0]  cnt  =   3'd0;
    always @(posedge clk_4000) cnt <=  cnt + 1'b1; // 计数器
////////////////////////////////////////////////////////////
    always @(*)
        case (cnt) // 行扫描
            3'd0: row   =   8'b0111_1111; // row[0]
            3'd1: row   =   8'b1011_1111; // row[1]
            3'd2: row   =   8'b1101_1111; // row[2]
            3'd3: row   =   8'b1110_1111; // row[3]
            3'd4: row   =   8'b1111_0111; // row[4]
            3'd5: row   =   8'b1111_1011; // row[5]
            3'd6: row   =   8'b1111_1101; // row[6]
            3'd7: row   =   8'b1111_1110; // row[7]
        endcase
////////////////////////////////////////////////////////////
    wire    [7:0]   col_r_data_unpacked  [0:7],
                    col_g_data_unpacked  [0:7];
    assign {    // 解包
        col_r_data_unpacked[7],
        col_r_data_unpacked[6],
        col_r_data_unpacked[5],
        col_r_data_unpacked[4],
        col_r_data_unpacked[3],
        col_r_data_unpacked[2],
        col_r_data_unpacked[1],
        col_r_data_unpacked[0]
    }   =   col_r_data;
    assign {    // 解包
        col_g_data_unpacked[7],
        col_g_data_unpacked[6],
        col_g_data_unpacked[5],
        col_g_data_unpacked[4],
        col_g_data_unpacked[3],
        col_g_data_unpacked[2],
        col_g_data_unpacked[1],
        col_g_data_unpacked[0]
    }   =   col_g_data;

    always @(*) begin // 多路选择器
        col_r   =   col_r_data_unpacked[cnt];
        col_g   =   col_g_data_unpacked[cnt];
    end
endmodule // dot88
