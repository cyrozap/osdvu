`timescale 1ns / 1ps
//*************************************************************
//
// Module: tb_uart
//
//** Description **********************************************   
//    
//  Test bench for uart module 
//
//** HISTORY **************************************************
//
// 07 Apr 13: initial design and test
//
//*************************************************************

module tb_uart;

    localparam clock_tick = 10;
    
        /* General shortcuts */
        localparam T = 1'b1;
        localparam F = 1'b0;
        
//** SIGNAL DECLARATIONS **************************************
 
    reg clk;
    reg reset;
    
    reg rx;
    wire tx;
    
    reg transmit;
    reg [7:0]tx_byte; 
    wire received; 
    wire [7:0] rx_byte;
    wire is_receiving; 
    wire is_transmitting; 
    wire recv_error; 
    wire [2:0] recv_state;
    wire [1:0] tx_state;


    reg i;

//** INSTANTIATE THE UNIT UNDER TEST(UUT)**********************

uart uart (
    .clk(clk), 
    .rst(reset), 
    .rx(rx), 
    .tx(tx), 
    .transmit(transmit), 
    .tx_byte(tx_byte), 
    .received(received), 
    .rx_byte(rx_byte), 
    .is_receiving(is_receiving), 
    .is_transmitting(is_transmitting), 
    .recv_error(recv_error), 
    .recv_state(recv_state), 
    .tx_state(tx_state)
    );

//** Clock ****************************************************     
 
    always begin
        clk = T;
		#(clock_tick/2);
		clk = F;
		#(clock_tick/2);
	end

//** UUT Tests ************************************************ 

    initial begin
    
        initial_conditions();
        reset_UUT();
        
        xmit_char(8'hAA);
        wait_while_transmitting;
        
        xmit_char(8'h55);
        wait_while_transmitting;
             
             
             
        //FIX ME - add tests for receive functions...     
             
        $finish;
  
    end

//** Tasks **************************************************** 
    
    task initial_conditions(); begin
        repeat(5) @(posedge clk)
        reset = F;     
    end endtask  


    task reset_UUT(); begin
        @(posedge clk)
        reset = T;
        @(posedge clk)
        reset = F;
    end endtask      
    
    
    task xmit_char(input integer C); begin   
        tx_byte = C;  
        @(posedge clk)
        transmit = T;
        @(posedge clk)
        transmit = F;
    end endtask 
    
    
    task wait_while_transmitting; begin
        @(negedge is_transmitting);
        repeat(10) @(posedge clk);
    end endtask


    task delay(input integer N); begin
        repeat(N) @(posedge clk);
    end endtask  

endmodule
