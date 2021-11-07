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
    output reg  m_axis_tvalid,
    output reg [C_M_AXIS_TDATA_WIDTH-1 : 0] m_axis_tdata,
    input wire  m_axis_tready,
    // Ports of Axi Slave Bus Interface S_AXIS,
    output wire  s_axis_tready,
    input wire [C_S_AXIS_TDATA_WIDTH-1 : 0] s_axis_tdata,
    input wire  s_axis_tvalid
);
wire  s_axis_tready_w;
reg   s_axis_tready_d_w;
reg   valid_d_r;
wire  mask_w;
reg   mask_d_r;
always@(posedge clk or negedge rstn)
begin
    if(!rstn)
        m_axis_tvalid <= 'b0;
    else
        m_axis_tvalid <= s_axis_tvalid;
end

always@(posedge clk or negedge rstn)
begin
    if(!rstn)
        m_axis_tdata <= 'd0;
    else if(s_axis_tvalid && s_axis_tready)
        m_axis_tdata <=  s_axis_tdata;
end

assign s_axis_tready_w = m_axis_tready || ~m_axis_tvalid;

always@(posedge clk or negedge rstn)
begin
    if(!rstn)
        s_axis_tready_d_w <= 'b0;
    else
        s_axis_tready_d_w <= s_axis_tready_w;
end

always@(posedge clk or negedge rstn)
begin
    if(!rstn)
        valid_d_r <= 'b0;
    else
        valid_d_r <= s_axis_tvalid;
end

assign mask_w = s_axis_tvalid && ~valid_d_r;

always@(posedge clk or negedge rstn)
begin
    if(!rstn)
        mask_d_r <= 'b0;
    else
        mask_d_r <= mask_w;
end

assign s_axis_tready = s_axis_tready_d_w && ~mask_d_r;


endmodule
