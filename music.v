module music(
    input           clk,
                    rst,
    input   [3:0]   note,
    output  reg     speaker
);
    reg         cnt_oct;
    reg [11:0]  cnt_note,
                clkdivider;

    always @(posedge clk or posedge rst)
        if (rst) begin
            cnt_note    <= clkdivider;
            cnt_oct     <= ~note[3];
            speaker <= 1'b0;
        end else begin
            cnt_note    <= cnt_note == 10'd0    ? clkdivider    : cnt_note  - 10'd1;
            if(cnt_note == 10'd0)
                cnt_oct <= cnt_oct  == 1'd0     ? ~note[3]      : cnt_oct   - 1'd1;
            else;
            if(cnt_note == 10'd0 && cnt_oct == 1'd0 && note[2:0])
                speaker <= ~speaker;
            else;
        end

    always @(*)
        case(note[2:0])
            3'd0: clkdivider    = 10'd0;   // 0
            3'd1: clkdivider    = 10'd946; // c1
            3'd2: clkdivider    = 10'd841; // d1
            3'd3: clkdivider    = 10'd757; // e1
            3'd4: clkdivider    = 10'd709; // f1
            3'd5: clkdivider    = 10'd630; // g1
            3'd6: clkdivider    = 10'd567; // a1
            3'd7: clkdivider    = 10'd504; // b1
        endcase
endmodule // music
