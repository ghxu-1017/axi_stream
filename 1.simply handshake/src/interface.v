
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
            input wire  m00_axis_tready,
            // Ports of Axi Slave Bus Interface S00_AXIS,
            input wire  s00_axis_tvalid,
            output wire  s00_axis_tready,
            input wire [C_S00_AXIS_TDATA_WIDTH-1 : 0] s00_axis_tdata
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
               .m_axis_tready(m00_axis_tready),
                // S_AXIS 
               .s_axis_tready(s00_axis_tready),
               .s_axis_tdata(s00_axis_tdata),
               .s_axis_tvalid(s00_axis_tvalid)
           );

	endmodule
