math.rad_to_deg = 57.29578049

function math.clamp(value, mi, ma)
    if value < mi then
        value = mi
    end
    if value > ma then
        value = ma
    end
    return value
end

function math.tri(i, m)
    return m - math.abs(i % (2 * m) - m)
end

function quat_to_euler(quat)
    local x = quat[1]
    local y = quat[2]
    local z = quat[3]
    local w = quat[4]
    yaw = math.atan2(2 * y * w - 2 * x * z, 1 - 2 * y * y - 2 * z * z);
    pitch = math.atan2(2 * x * w - 2 * y * z, 1 - 2 * x * x - 2 * z * z);
    roll = math.asin(2 * x * y + 2 * z * w);
    return Vec(pitch, yaw, roll)
end

function stepify_angle(angle, step_angle)
    if step_angle == 0 then
        return 0
    end
    return math.floor(angle / step_angle) * step_angle % 360
end

function get_table_length(table)
    local length = 0
    for _ in pairs(table) do
        length = length + 1
    end
    return length
end
