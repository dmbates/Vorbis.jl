function readcddb(fnm::AbstractString)
    nms = ASCIIString[]
    vv = ByteString[]
    open(fnm,"r") do io
        for ln in eachline(io)
            ismatch(r"^\s*#",ln) && next
            vals = map(strip,split(chomp(ln),"="))
            if length(vals) == 2 && length(vals[2]) > 0
                push!(nms,vals[1])
                push!(vv,vals[2])
            end
        end
    end
    nms,vv
end

function readinf(nm::ByteString)
    res = Dict{ASCIIString,ByteString}()
    if isfile(nm)
        open(nm,"r") do io
            for ln in eachline(io)
                vals = map(strip,split(split(chomp(ln),"#")[1],"="))
                if length(vals) == 2 && length(vals[2]) > 0
                    res[vals[1]] = strip(vals[2],'\'')
                end
            end
        end
    end
    res
end

function process_dir(dnm::ByteString)
    cd(dnm) do
        for nm in readdir()
            bb,ee = splitext(nm)
            if ee == ".wav"
                meta = readinf(string(bb,".inf"))
                hdr,
                               
