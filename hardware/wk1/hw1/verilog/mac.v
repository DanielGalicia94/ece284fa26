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
reg signed [psum_bw-1:0] psum_q_stable;
wire signed [psum_bw:0] psum_curr;
wire signed [psum_bw-1:0] result;

wire zero = 0;

wire signed [bw-1:0] a_f, b_f;

// Turning sign n mag to 2's comp
wire A_sign, B_sign;

wire signed [bw-1:0] a_mag = {zero,a_q[bw-2:0]};
wire signed [bw-1:0] b_mag = {zero,b_q[bw-2:0]};

assign A_sign = a_q[bw-1];
assign B_sign = b_q[bw-1];

wire signed [bw-1:0] a_t;
wire signed [bw-1:0] b_t;

assign a_t = A_sign ? -a_mag : a_mag;  
assign b_t = B_sign ? -b_mag : b_mag; 

//desiding what format to use
assign a_f = format ? a_t : a_q;
assign b_f = format ? b_t : b_q;

assign result = acc ? a_f*b_f+psum_q_stable : a_f*b_f;

wire MagNeg = result[psum_bw-1];
wire signed [psum_bw-1:0]MagAbs = MagNeg ? -result: result;
wire signed [psum_bw-1:0] Mag_Out = {MagNeg,MagAbs[psum_bw-2:0]};

wire signed [psum_bw-1:0] final = format ? Mag_Out : result;

always @ (posedge clk) begin
    if (reset) begin
        psum_q <= 0;
        psum_q_stable <= 0;
    end else
    begin
        psum_q <= final;
        psum_q_stable <= result;
    end
    b_q  <= B;
    a_q  <= A;
end

endmodule
