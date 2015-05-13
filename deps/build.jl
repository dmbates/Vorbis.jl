using BinDeps
using Compat

@BinDeps.setup

ogg = library_dependency("libogg")
flac = library_dependency("libflac",aliases=["libFLAC"])
vorbis = library_dependency("libvorbis")
vorbisenc = library_dependency("libvorbisenc")
vorbisfile = library_dependency("libvorbisfile")

provides(AptGet,"libogg-dev",ogg)
provides(AptGet,"libflac-dev",flac)
provides(AptGet,"libvorbis-dev",[vorbis,vorbisenc,vorbisfile])

@BinDeps.install Dict(:libogg => :ogg,
                      :libflac => :flac,
                      :libvorbis => :vorbis, 
                      :libvorbisenc => :vorbisenc,
                      :libvorbisfile => :vorbisfile)
