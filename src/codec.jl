init(vi::VorbisInfo) = ccall((:vorbis_info_init,vorbisenc),Void,(Ref{VorbisInfo},),vi)
clear(vi::VorbisInfo) = ccall((:vorbis_info_clear,vorbisenc),Void,(Ref{VorbisInfo},),vi)

info_blocksize(vi::VorbisInfo,zo) =
    ccall((:vorbis_info_blocksize,vorbisenc),Cint,(Ref{VorbisInfo},Cint),vi,zo)

init(vc::VorbisComment) = ccall((:vorbis_comment_init,vorbisenc),Void,(Ref{VorbisComment},Cint),vc)

comment_add(vc::VorbisComment,c::ByteString) =
    ccall((:vorbis_comment_add,vorbisenc),Void,(Ref{VorbisComment},Ptr{Uint8}),vc,c)
comment_add_tag(vc::VorbisComment,t::ByteString,c::ByteString) =
    ccall((:vorbis_comment_add_tag,vorbisenc),Void,
          (Ref{VorbisComment},Ptr{Uint8},Ptr{Uint8}),vc,t,c)

comment_query(vc::VorbisComment,t::ByteString,count) =
    bytestring(ccall((:vorbis_comment_query,vorbisenc),Ptr{Uint8},
                     (Ref{VorbisComment},Ptr{Uint8},Cint),c,t,count))

comment_query_count(vc::VorbisComment,t::ByteString) =
    ccall((:vorbis_comment_query_count,vorbisenc),Cint,
          (Ref{VorbisComment},Ptr{Uint8}),c,t)

clear(vc::VorbisComment) = ccall((:vorbis_comment_clear,vorbisenc),Void,(Ref{VorbisComment},),vc)

init(v::VorbisDSPState,vb::VorbisBlock) = 
    ccall((:vorbis_block_init,vorbisenc),Cint,(Ref{VorbisDSPState},Ref{VorbisBlock}),v,vb)

clear(vb::VorbisBlock) = ccall((:vorbis_block_clear,vorbisenc),Cint,(Ref{VorbisBlock},),vb)
clear(v::VorbisDSPState) = ccall((:vorbis_dsp_clear,vorbisenc),Cint,(Ref{VorbisDSPState},),v)
init(v::VorbisDSPState,vi::VorbisInfo) =
    ccall((:vorbis_analysis_init,vorbisenc),Cint,(Ref{VorbisDSPState},Ref{VorbisInfo}),v,vi)
commentheader_out(vc::VorbisComment,op::Ogg.Packet) =
    ccall((:vorbis_commentheader_out,vorbisenc),Cint,(Ref{VorbisComment},Ref{Ogg.Packet}),vc,op)
analysis_header_out(v::VorbisDSPState,vc::VorbisComment,op::Ogg.Packet) =
    ccall((:vorbis_analysis_headerout,vorbis),Cint,
          (Ref{VorbisDSPState},Ref{VorbisComment},Ref{Ogg.Packet}),v,vc,op)
analysis_buffer(v::VorbisDSPState,vals) =
    ccall((:vorbis_analysis_buffer,vorbisenc),Ptr{Ptr{Cfloat}},
          (Ref{VorbisDSPState},Cint),v,vals)
analysis_wrote(v::VorbisDSPState,vals) =
    ccall((:vorbis_analysis_wrote,vorbisenc),Cint,
          (Ref{VorbisDSPState},Cint),v,vals)

analysis_blockout(v::VorbisDSPState,vb::VorbisBlock) =
    ccall((:vorbis_analysis_blockout,vorbisenc),Cint,
          (Ref{VorbisDSPState},Ref{VorbisBlock}),v,vb)

analysis(vb::VorbisBlock,op::Ogg.Packet) =
    ccall((:vorbis_analysis,vorbisenc),Cint,
          (Ref{VorbisBlock},Ref{Ogg.Packet}),vb,op)

bitrate_addblock(vb::VorbisBlock) =
    ccall((:vorbis_bitrate_addblock,vorbisenc),Cint,
          (Ref{VorbisBlock},),vb)

bitrate_flushpacket(v::VorbisDSPState,op::Ogg.Packet) =
    ccall((:vorbis_bitrate_flushpacket,vorbisenc),Cint,
          (Ref{VorbisDSPState},Ref{Ogg.Packet}),vb,op)


