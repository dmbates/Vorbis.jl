immutable VorbisInfo
    version::Cint
    channels::Cint
    rate::Clong

    bitrate_upper::Clong
    bitrate_nominal::Clong
    bitrate_lower::Clong
    bitrate_window::Clong

    codec_setup::Ptr{Void}
end

VorbisInfo() = VorbisInfo(0,0,0,0,0,0,0,C_NULL)

immutable VorbisDSPState
    analysisp::Cint
    vorbis_info::VorbisInfo

    pcm::Ptr{Cfloat}
    pcmret::Ptr{Cfloat}
    pcm_storage::Cint
    pcm_current::Cint
    pcm_returned::Cint

    preextrapolate::Cint
    eofflag::Cint

    lW::Clong
    W::Clong
    nW::Clong
    ceneterW::Clong

    granulepos::Int64
    sequence::Int64

    glue_bits::Int64
    time_bits::Int64
    floor_bits::Int64
    res_bits::Int64

    backend_state::Ptr{Void}
end

immutable AllocChain
    ptr::Ptr{Void}
    next::Ptr{AllocChain}
end


immutable VorbisBlock
    pcm::Ptr{Ptr{Cfloat}}
    opb::Ogg.PackBuffer

    lW::Clong
    W::Clong
    nW::Clong
    pcmend::Cint
    mode::Cint

    eofflag::Cint
    granulepos::Int64
    sequence::Int64
    vd::Ptr{VorbisDSPState}
    
    localstore::Ptr{Void}
    localtop::Clong
    localalloc::Clong
    totaluse::Clong
    reap::Ptr{AllocChain}
    
    glue_bits::Int64
    time_bits::Int64
    floor_bits::Int64
    res_bits::Int64

    internal::Ptr{Void}
end

immutable VorbisComment
    user_comments::Ptr{Ptr{Cuchar}}
    comment_lengths::Ptr{Cint}
    comments::Cint
    vendor::Ptr{Cuchar}
end
