immutable OVCallbacks
    read_func::Ptr{Void}
    seek_func::Ptr{Void}
    close_func::Ptr{Void}
    tell_func::Ptr{Void}
end

immutable OggVorbisFile
    datasource::Ptr{Void}
    seekable::Cint
    offset::Int64
    nd::Int64
    oy::Ogg.SyncState
    links::Cint
    offsets::Ptr{Int64}
    dataoffsets::Ptr{Int64}
    serialnos::Ptr{Clong}
    pcmlengths::Int64
    vi::Ptr{VorbisInfo}
    vc::Ptr{VorbisComment}
    pcm_offset::Int64
    ready_state::Cint
    current_serialno::Clong
    current_link::Cint
    bittrack::Cdouble
    samptrack::Cdouble
    os::Ogg.StreamState
    vd::VorbisDSPState
    vb::VorbisBlock
    callbacks::OVCallbacks
end

clear(vf::OggVorbisFile) =
    ccall((:ov_clear,vorbisfile),Cint,(Ref{OggVorbisFile},),vf)
fopen(path::AbstractString,vf::OggVorbisFile) =
    ccall((:ov_fopen,vorbisfile),Cint,(Cstring,Ref{OggVorbisFile}),path,vf)

    
