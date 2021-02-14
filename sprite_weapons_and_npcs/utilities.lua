function math.clamp(value, mi, ma)
    if value < mi then value = mi end
    if value > ma then value = ma end
    return value
end
