function math.sign(x)
    return (x > 0) and 1 or (x < 0) and -1 or 0
end

function GetDirection(argument)
    if (argument % 2 == 0) then
        return "left"
    else
        return "right"
    end
end

---надо будет ещё math.clamp написать