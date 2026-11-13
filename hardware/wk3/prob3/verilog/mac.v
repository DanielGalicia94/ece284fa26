// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac (out, a, b, c);

parameter bw = 4;
parameter psum_bw = 16;

input [bw-1:0] a; 
input signed [bw-1:0] b;
input signed [psum_bw-1:0] c;
output signed [psum_bw-1:0] out;

wire zero = 0;
wire one = 1;

wire b_sign = b[bw-1];
wire [bw-1:0] unSignedB = b_sign ? -b : b;

wire signed [psum_bw-1:0] mult = b_sign? -(unSignedB * a) : (unSignedB * a); 

assign out = mult + c; 

endmodule
