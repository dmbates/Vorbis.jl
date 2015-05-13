module Vorbis

export OggVorbisFile,
       WAVHeader,
       
       WAVopen,
       clear,
       flacwrite,
       init,
       process_dir
       
const depfile = joinpath(dirname(@__FILE__), "..", "deps", "deps.jl")
if isfile(depfile)
    include(depfile)
else
    error("Vorbis not properly installed. Please run Pkg.build(\"Vorbis\")")
end

include("WAV.jl")
include("ogg_h.jl")
include("codec_h.jl")
include("codec.jl")
include("vorbisfile.jl")
include("vorbisenc.jl")
include("flac.jl")

end # module
