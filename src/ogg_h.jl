module Ogg

## FIXME within the module, remove the Ogg prefix in the type names
immutable IOVec
    iov_base::Ptr{Void}
    iov_len::Csize_t
end

immutable PackBuffer
    endbyte::Clong
    endbit::Cint

    buffer::Ptr{Cuchar}
    ptr::Ptr{Cuchar}
    storage::Clong
end

@doc "Encapsulate the data in one Ogg bitstream page"->
immutable Page
    header::Ptr{Cuchar}
    header_len::Clong
    body::Ptr{Cuchar}
    body_len::Clong
end

@doc """
Contains the current encode/decode state of a logical Ogg bitstream.
"""->
immutable StreamState
    body_data::Ptr{Cuchar}         # bytes from packet bodies
    body_storage::Clong            # elements allocated
    body_fill::Clong               # elements stored; fill mark
    body_returned::Clong           # elements of fill returned

    lacing_vals::Ptr{Cint}         # values to go in segment table
    granule_vals::Ptr{Int64}       # granulepos values for headers
    lacing_storage::Clong
    lacing_fill::Clong
    lacing_packet::Clong
    lacing_returned::Clong

    header::NTuple{282,Cuchar}     # working space for header encoding
    e_o_s::Cint                    # set on end of stream
    b_o_s::Cint                    # set after writing initial page

    serialno::Clong
    pageno::Clong
    packetno::Int64
    granulepos::Int64
end

@doc """
Encapsulate the data and metadata belonging to a single
raw Ogg/Vorbis packet
"""->
immutable Packet
    packet::Ptr{Cuchar}
    bytes::Clong
    b_o_s::Clong
    e_o_s::Clong

    granulepos::Int64

    packetno::Int64
end

immutable SyncState
    data::Ptr{Cuchar}
    storage::Cint
    fill::Cint
    returned::Cint

    unsynced::Cint
    headerbytes::Cint
    bodybytes::Cint
end

## Ogg Bitstream Primitives: bitstream
## I skipped the C functions beginning with oggpackB_ b/c they
## seem to be the same as the corresponding oggpack_ C function.

for (rtyp,nm) in ((:Void,:writeinit),
                  (:Cint,:writecheck),
                  (:Void,:writealign),
                  (:Void,:reset),
                  (:Void,:writeclear),
                  (:Clong,:look1),
                  (:Void,:adv1),
                  (:Clong,:read1),
                  (:Clong,:bytes),
                  (:Clong,:bits),
                  ("Ptr{Cuchar}",:get_buffer))
    @eval begin
        $nm(b::PackBuffer) =
            ccall(($(string("oggpack_",nm)),ogg),$rtyp,
                  (Ref{PackBuffer},),b)
    end
end

writetrunc(b::PackBuffer,bits) =
    ccall((:oggpack_writetrunc,ogg),Void,
          (Ref{PackBuffer},Clong),b,bits)

writecopy(b::PackBuffer,source,bits) =
    ccall((:oggpack_writecopy),Void,
          (Ref{Packbuffer},Ptr{Void},Clong),b,source,bits)

readinit(b::PackBuffer,buf,bytes) =
    ccall((:oggpack_readinit,ogg),Void,
          (Ref{PackBuffer},Ptr{Cuchar},Cint),b,buf,bytes)

Base.write(b::PackBuffer,value,bits) =
    ccall((:oggpack_write,ogg),Void,
          (Ref{PackBuffer},Culong,Cint),b,value,bits)

Base.read(b::PackBuffer,bits) =
    ccall((:oggpack_read,ogg),Culong,
          (Ref{PackBuffer},Cint),b,bits)

for (nm,rtyp) in ((:look,:Clong),(:adv,:Void))
    @eval begin
        $nm(b::PackBuffer,bits) =
            ccall(($(string("oggpack_",nm)),ogg),Clong,
                  (Ref{PackBuffer},Cint),b,bits)
    end
end

## Ogg Bitstream primitives: encoding

packetin(os::StreamState,op::Packet) =
    ccall((:ogg_stream_packetin,ogg),Cint,
          (Ref{StreamState},Ref{Packet}),os,op)

iovecin(os::StreamState,iov::IOVec,count,e_o_s,granulepos) =
    ccall((:ogg_stream_iovecin,ogg),Cint,
          (Ref{StreamState},Ref{IOVec},Cint,Clong,Int64),
          os,iov,count,e_o_s,granulepos)

for nm in (:pageout,:flush)
    @eval begin
        $nm(os::StreamState,og::Page) =
            ccall(($(string("ogg_stream_",nm)),ogg),Cint,
                  (Ref{StreamState},Ref{Page}),os,og)
        $nm(os::StreamState,og::Page,nfill) =
            ccall(($(string("ogg_stream_",nm,"_fill")),ogg),Cint,
                  (Ref{StreamState},Ref{Page},Cint),os,og,nfill)
    end
end

## Ogg Bitstream primitives: decoding

for nm in (:init,:clear,:reset,:destroy,:check)
    @eval begin
        $nm(oy::SyncState) =
            ccall(($(string("ogg_sync_",nm)),ogg),Cint,
                  (Ref{SyncState},),oy)
    end
end

buffer(oy::SyncState,sz) =
    ccall((:ogg_sync_buffer,ogg),Ptr{Cuchar},
          (Ref{SyncState},Clong),oy,sz)

wrote(oy::SyncState,bytes) =
    ccall((:ogg_sync_wrote,ogg),Cint,
          (Ref{SyncState},Clong),oy,bytes)

for (nm,rtyp) in ((:pageseek,:Clong),(:pageout,:Cint))
    @eval begin
        $nm(oy::SyncState,op::Page) =
            ccall(($(string("ogg_sync_",nm)),ogg),$rtyp,
                  (Ref{SyncState},Ref{Page}),oy,op)
    end
end

pagein(os::StreamState,og::Page) =
    ccall((:ogg_stream_pagein,ogg),Cint,
          (Ref{StreamState},Ref{Page}),os,og)

packetout(os::StreamState,op::Packet) =
    ccall((:ogg_stream_packetout,ogg),Cint,
          (Ref{StreamState},Ref{Packet}),os,op)

packetpeek(os::StreamState,op::Packet) =
    ccall((:ogg_stream_packetpeek,ogg),Cint,
          (Ref{StreamState},Ref{Packet}),os,op)

## Ogg Bitstream primitives: general

for nm in (:clear,:reset,:destroy,:check,:eos)
    @eval begin
        $nm(os::StreamState) =
            ccall(($(string("ogg_stream_",nm)),ogg),Cint,
                  (Ref{StreamState},),os)
    end
end

for nm in (:init,:reset_serialno)
    @eval begin
        $nm(os::StreamState,sn) =
            ccall(($(string("ogg_stream_",nm)),ogg),Cint,
                  (Ref{StreamState},Cint),os,sn)
    end
end

for (nm,rtyp) in ((:checksum_set,:Void),
                  (:version,:Cint),
                  (:bos,:Cint),
                  (:eos,:Cint),
                  (:granulepos,:Int64),
                  (:serialno,:Cint),
                  (:pageno,:Clong),
                  (:packets,:Cint))
    @eval begin
        $nm(og::Page) =
            ccall(($(string("ogg_page_",nm)),ogg),$rtyp,
                  (Ref{Page},),og)
    end
end

clear(op::Packet) =
    ccall((:ogg_packet_clear,ogg),Void,(Ref{Packet},),op)

end
