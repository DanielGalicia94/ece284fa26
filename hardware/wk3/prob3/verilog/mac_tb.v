// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 


module mac_tb;

parameter bw = 4;
parameter psum_bw = 16;

reg clk = 0;

// for normal mac
//reg  [bw-1:0] a;
//reg  [bw-1:0] b;

//for mac extended or q3
reg  [bw-1:0] a1, a2, a3, a4;
reg  [bw-1:0] b1, b2, b3, b4;

reg  [psum_bw-1:0] c;
wire [psum_bw-1:0] out;
reg  [psum_bw-1:0] expected_out = 0;

integer w_file ; // file handler
integer w_scan_file ; // file handler

integer x_file ; // file handler
integer x_scan_file ; // file handler

//for normal mac
//integer x_dec;
//integer w_dec;

//for mac extended
integer x1_dec, x2_dec, x3_dec, x4_dec;
integer w1_dec, w2_dec, w3_dec, w4_dec;

integer i; 
integer u; 

function [3:0] w_bin ;
  input integer  weight ;
  begin

    if (weight>-1)
     w_bin[3] = 0;
    else begin
     w_bin[3] = 1;
     weight = weight + 8;
    end

    if (weight>3) begin
     w_bin[2] = 1;
     weight = weight - 4;
    end
    else 
     w_bin[2] = 0;

    if (weight>1) begin
     w_bin[1] = 1;
     weight = weight - 2;
    end
    else 
     w_bin[1] = 0;

    if (weight>0) 
     w_bin[0] = 1;
    else 
     w_bin[0] = 0;

  end
endfunction



function [3:0] x_bin ;
  input integer x;
  begin
    if (x > 7) begin
      x_bin[3] = 1;
      x = x - 8;
    end else x_bin[3] = 0; 
    
    if (x > 3) begin
      x_bin[2] = 1;
      x = x - 4;
    end else x_bin[2] = 0;
    
    if (x > 1) begin
      x_bin[1] = 1;
      x = x - 2;
    end else x_bin[1] = 0;
    
    if (x > 0) x_bin[0] = 1;
    else x_bin[0] = 0;
  end
endfunction


// Below function is for verification
function [psum_bw-1:0] mac_predicted;
  input [bw-1:0] a;
  input [bw-1:0] b;
  input [psum_bw-1:0] c;
  begin
    // apparently this works, would have loved to know this
    // before doing my own mac implementation 
      mac_predicted = $signed({1'b0, a}) * $signed(b) + $signed(c);
  end
endfunction


/*/
mac_wrapper #(.bw(bw), .psum_bw(psum_bw)) mac_wrapper_instance (
	.clk(clk), 
        .a(a), 
        .b(b),
        .c(c),
	.out(out)
); 
/**/ 

/**/
mac_wrapper_extend #(.bw(bw), .psum_bw(psum_bw)) mac_wrapper_instance (
    .clk(clk),
    .a1(a1), .a2(a2), .a3(a3), .a4(a4),
    .b1(b1), .b2(b2), .b3(b3), .b4(b4),
    .c(c),
    .out(out)
);
/**/

initial begin 

  w_file = $fopen("b_data.txt", "r");  //weight data
  x_file = $fopen("a_data.txt", "r");  //activation

  $dumpfile("mac_tb.vcd");
  $dumpvars(0,mac_tb);
 
  #1 clk = 1'b0;  
  #1 clk = 1'b1;  
  #1 clk = 1'b0;

  $display("-------------------- Computation start --------------------");
  

  //for (i=0; i<10; i=i+1) begin  // Data lenght is 10 in the data files
  for (i=0; i<5; i=i+1) begin // for extended version
  

     #1 clk = 1'b1;
     #1 clk = 1'b0;

     /*/
     w_scan_file = $fscanf(w_file, "%d\n", w_dec);
     x_scan_file = $fscanf(x_file, "%d\n", x_dec);

     a = x_bin(x_dec); // unsigned number
     b = w_bin(w_dec); // signed number
     
     c = expected_out;

     expected_out = mac_predicted(a, b, c);
     /**/
     
     // for extended test bench
     /**/
     w_scan_file = $fscanf(w_file, "%d %d %d %d", w1_dec, w2_dec, w3_dec, w4_dec);
     x_scan_file = $fscanf(x_file, "%d %d %d %d", x1_dec, x2_dec, x3_dec, x4_dec);
     
     a1 = x_bin(x1_dec);  a2 = x_bin(x2_dec);  a3 = x_bin(x3_dec);  a4 = x_bin(x4_dec);
     b1 = w_bin(w1_dec);  b2 = w_bin(w2_dec);  b3 = w_bin(w3_dec);  b4 = w_bin(w4_dec);
     c  = expected_out;
     
     expected_out = mac_predicted(a4, b4,
                    mac_predicted(a3, b3,
                    mac_predicted(a2, b2,
                    mac_predicted(a1, b1, c))));
     /**/

  end



  #1 clk = 1'b1;
  #1 clk = 1'b0;

  $display("-------------------- Computation completed --------------------");

  #10 $finish;


end

endmodule




