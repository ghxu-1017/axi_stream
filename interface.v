
`timescale 1 ns / 1 ps

	module interface #
    (
    
            // Parameters of Axi Master Bus Interface M00_AXIS
            parameter integer C_M00_AXIS_TDATA_WIDTH    = 32,
            // Parameters of Axi Slave Bus Interface S00_AXIS
            parameter integer C_S00_AXIS_TDATA_WIDTH    = 32
        )
        (
             // Global Clock and REST Signal
            input wire  aclk,
            input wire  aresetn,
           
           // Ports of Axi Master Bus Interface M00_AXIS
            output wire  m00_axis_tvalid,
            output wire [C_M00_AXIS_TDATA_WIDTH-1 : 0] m00_axis_tdata,
            output wire  m00_axis_tlast,
            input wire  m00_axis_tready,
            output wire  m00_axis_tuser,
            // Ports of Axi Slave Bus Interface S00_AXIS,
            input wire  s00_axis_tvalid,
            output wire  s00_axis_tready,
            input wire [C_S00_AXIS_TDATA_WIDTH-1 : 0] s00_axis_tdata,
            input wire  s00_axis_tlast,
            input wire  s00_axis_tuser
           );
           interface_if  #
           (
             .C_S_AXIS_TDATA_WIDTH(C_S00_AXIS_TDATA_WIDTH),
          
             .C_M_AXIS_TDATA_WIDTH(C_M00_AXIS_TDATA_WIDTH)
           )
            interface_if
           (
            // Global 
               .clk(aclk),
               .rstn(aresetn),       
                 // M_AXIS  
               .m_axis_tvalid(m00_axis_tvalid),
               .m_axis_tdata(m00_axis_tdata),
               .m_axis_tlast(m00_axis_tlast),
               .m_axis_tready(m00_axis_tready),
               . m_axis_tuser(m00_axis_tuser),
                // S_AXIS 
               .s_axis_tready(s00_axis_tready),
               .s_axis_tdata(s00_axis_tdata),
               .s_axis_tlast(s00_axis_tlast),
               .s_axis_tvalid(s00_axis_tvalid), 
                .s_axis_tuser(s00_axis_tuser)
           );

	endmodule
