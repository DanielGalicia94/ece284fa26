// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac (out, A, B, format, acc, clk, reset);

parameter bw = 8;
parameter psum_bw = 16;

input clk;
input acc;
input reset;
input format;

input signed [bw-1:0] A;
input signed [bw-1:0] B;

output signed [psum_bw-1:0] out;

reg signed [psum_bw-1:0] psum_q;
reg signed [bw-1:0] a_q;
reg signed [bw-1:0] b_q;

assign out = psum_q;

// Your code goes here
wire signed [psum_bw-1:0] result;
assign result = acc ? a_q*b_q+psum_q : a_q*b_q;

wire MagNeg = result[psum_bw-1];
wire signed [psum_bw-1:0]MagAbs = MagNeg ? -result: result;
wire signed [psum_bw-1:0] Mag_Out = {MagNeg,MagAbs[psum_bw-2:0]};

wire signed [psum_bw-1:0] final = format ? Mag_Out : result;

always @ (posedge clk) begin
    if (reset) begin
        psum_q <= 0;
    end
    b_q  <= B;
    a_q  <= A;
    psum_q <=final;
end

endmodule
