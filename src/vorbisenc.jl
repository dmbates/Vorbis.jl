encode_init(vi::VorbisInfo,channels,rate,max_bitrate,nominal,min_bitrate) =
    ccall((:vorbis_encode_init,vorbisenc),Cint,
          (Ref{VorbisInfo},Clong,Clong,Clong,Clong,Clong),
          vi,channels,rate,max_bitrate,nominal,min_bitrate)

encode_setup_managed(vi::VorbisInfo,channels,rate,max_bitrate,nominal,min_bitrate) =
    ccall((:vorbis_encode_setup_managed,vorbisenc),Cint,
          (Ref{VorbisInfo},Clong,Clong,Clong,Clong,Clong),
          vi,channels,rate,max_bitrate,nominal,min_bitrate)

encode_setup_vbr(vi::VorbisInfo,channels,rate,quality) =
    ccall((:vorbis_encode_setup_vbr,vorbisenc),Cint,
          (Ref{VorbisInfo},Clong,Clong,Cfloat),vi,channels,rate,quality)

encode_init_vbr(vi::VorbisInfo,channels,rate,quality) =
    ccall((:vorbis_encode_init_vbr,vorbisenc),Cint,
          (Ref{VorbisInfo},Clong,Clong,Cfloat),vi,channels,rate,quality)

encode_setup_init(vi::VorbisInfo) =
    ccall((:vorbis_encode_setup_init,vorbisenc),Cint,(Ref{VorbisInfo},),vi)

immutable RateManage
    mangement_active::Cint
    bitrate_hard_min::Clong
    bitrate_hard_max::Clong
    bitrate_hard_window::Cdouble
    bitrate_av_lo::Clong
    bitrate_av_hi::Clong
    bitrate_av_window::Cdouble
    bitrate_av_window_center::Cdouble
end

immutable RateManage2
    management_active::Cint
    bitrate_limit_min_kbps::Clong
    bitrate_limit_max_kbps::Clong
    bitrate_limit_reservoir_bits::Clong
    bitrate_limit_reservoir_bias::Cdouble
    bitrate_average_kbps::Clong
    bitrate_average_damping::Cdouble
end

