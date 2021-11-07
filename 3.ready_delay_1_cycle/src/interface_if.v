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
    // Ports of Axi Slave Bus Interface S_AXIS,
    output reg  s_axis_tready,
    input wire [C_S_AXIS_TDATA_WIDTH-1 : 0] s_axis_tdata,
    input wire  s_axis_tvalid
);

always@(posedge clk or negedge rstn)
begin
    if(!rstn)
        s_axis_tready <= 'b0;
    else
        s_axis_tready <= m_axis_tready;
end


assign m_axis_tdata = s_axis_tdata;
assign m_axis_tvalid = s_axis_tvalid;


endmodule
