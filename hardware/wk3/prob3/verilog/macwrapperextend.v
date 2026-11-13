// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac_wrapper_extend (clk, out, a1, a2, a3, a4, b1, b2, b3, b4, c);

parameter bw = 4;
parameter psum_bw = 16;

output [psum_bw-1:0] out;
input  [bw-1:0] a1, a2, a3, a4;
input  [bw-1:0]  b1, b2, b3, b4;
input  [psum_bw-1:0] c;
input  clk;

reg    [bw-1:0] a1_q, a2_q, a3_q, a4_q;
reg    [bw-1:0] b1_q, b2_q, b3_q, b4_q;
reg    [psum_bw-1:0] c_q;

wire signed [psum_bw-1:0] out1, out2, out3, out4, out5;
wire signed [psum_bw-1:0] zero = 0;
wire signed [psum_bw-1:0] cin = c_q;

mac #(.bw(bw), .psum_bw(psum_bw)) mac_instance1 (
        .a(a1_q), 
        .b(b1_q),
        .c(zero),
	.out(out1)
); 

mac #(.bw(bw), .psum_bw(psum_bw)) mac_instance2 (
        .a(a2_q), 
        .b(b2_q),
        .c(zero),
	.out(out2)
); 

mac #(.bw(bw), .psum_bw(psum_bw)) mac_instance3 (
        .a(a3_q), 
        .b(b3_q),
        .c(zero),
	.out(out3)
); 

mac #(.bw(bw), .psum_bw(psum_bw)) mac_instance4 (
        .a(a4_q), 
        .b(b4_q),
        .c(zero),
	.out(out4)
); 

// the parenthesis are the onlything keeping the structure
assign out = cin + ((out1 + out2) + (out3 + out4));


always @ (posedge clk) begin
        b1_q  <= b1;
        b2_q  <= b2;
        b3_q  <= b3;
        b4_q  <= b4;
        a1_q  <= a1;
        a2_q  <= a2;
        a3_q  <= a3;
        a4_q  <= a4;
        c_q  <= c;
end

endmodule

