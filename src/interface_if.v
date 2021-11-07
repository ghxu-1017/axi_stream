`timescale 1ns / 1ps

module interface_if #
(
    // Parameters of Axi Master Bus Interface M00_AXIS
    parameter integer C_M_AXIS_TDATA_WIDTH    = 32,
    // Parameters of Axi Slave Bus Interface S00_AXIS
    parameter integer C_S_AXIS_TDATA_WIDTH    = 32
)
(
    //gobal
     input wire clk,
     input wire rstn,
    // Ports of Axi Master Bus Interface M_AXIS
    output wire  m_axis_tvalid,
    output wire [C_M_AXIS_TDATA_WIDTH-1 : 0] m_axis_tdata,
    input wire  m_axis_tready,
    output wire  m_axis_tlast,//EOL
    output wire  m_axis_tuser,//SOF
    // Ports of Axi Slave Bus Interface S_AXIS,
    output wire  s_axis_tready,
    input wire [C_S_AXIS_TDATA_WIDTH-1 : 0] s_axis_tdata,
    input wire  s_axis_tvalid,
    input wire  s_axis_tlast,//EOL
    input wire  s_axis_tuser
);


    
//*** PARAMETER DECLARATION ***************************************************
//defination  fifo
//recevice fifo
wire fifo_rst;
wire  rev_fifo_wr_en;
wire  rev_fifo_rd_en;
wire [31:0]rev_fifo_out;
wire [31:0]rev_fifo_in;
wire rev_fifo_full;
wire rev_fifo_empty;
//send fifo 
wire  send_fifo_wr_en;
wire  send_fifo_rd_en;
wire [31:0]send_fifo_out;
wire [31:0]send_fifo_in;
wire send_fifo_full;
wire send_fifo_empty;
//*** main ****************************************************
//axis_slaver opt rev_fifo
assign fifo_rst = ~rstn;
assign s_axis_tready =  ~rev_fifo_full ;
assign rev_fifo_wr_en = s_axis_tready && s_axis_tvalid;
assign rev_fifo_in = s_axis_tdata;
assign rev_fifo_rd_en = !rev_fifo_empty ;


fifo_4096_32 rev_fifo_4096_32 (
  .clk(clk),      // input wire clk
  .srst(fifo_rst),    // input wire srst
  .din(rev_fifo_in),      // input wire [31 : 0] din
  .wr_en(rev_fifo_wr_en),  // input wire wr_en
  .rd_en(rev_fifo_rd_en),  // input wire rd_en
  .dout(rev_fifo_out),    // output wire [31 : 0] dout
  .full(rev_fifo_full),    // output wire full
  .empty(rev_fifo_empty)  // output wire empty
);//depth 4096 ,witdth 32 


//axis_master  opt send_fifo
assign m_axis_tvalid = ~send_fifo_empty;
assign send_fifo_in = rev_fifo_out;
assign send_fifo_wr_en = rev_fifo_rd_en;
assign send_fifo_rd_en = m_axis_tvalid && m_axis_tready;
assign m_axis_tdata = send_fifo_out;

//assign  send_fifo_wr_en 
fifo_4096_32 send_fifo_4096_32 (
  .clk(clk),      // input wire clk
  .srst(fifo_rst),    // input wire srst
  .din(send_fifo_in),      // input wire [31 : 0] din
  .wr_en(send_fifo_wr_en),  // input wire wr_en
  .rd_en(send_fifo_rd_en),  // input wire rd_en
  .dout(send_fifo_out),    // output wire [31 : 0] dout
  .full(send_fifo_full),    // output wire full
  .empty(send_fifo_empty)  // output wire empty
);//depth 4096 ,witdth 32 


endmodule
