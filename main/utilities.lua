--function QuatToEuler(quat)
--    local x, y, z, w = quat[1], quat[2], quat[3], quat[4]
--    local s = math.sqrt(1 - w * w)
--    s = s < .0001 and 1 or 1 / s
--    local vec = VecNormalize(Vec(x * s, y * s, z * s))
--    DebugPrint(tostring(vec[1]) .. " " .. tostring(vec[2]) .. " " .. tostring(vec[3]))
--    return vec
--end

function QuatToEuler(quat)
    local vec = TransformToParentVec()
    DebugPrint(tostring(vec[1]) .. " " .. tostring(vec[2]) .. " " .. tostring(vec[3]))
    return vec
end
