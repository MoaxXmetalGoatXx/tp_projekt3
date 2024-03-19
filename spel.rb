require 'ruby2d'
set title: "spel"
health=100
maxhealth=100
maxstamina=60
stamina=60
gamestart=false
character=nil
attribute=nil
if gamestart==false
    hero_square=Rectangle.new(x:20, y:160, width:190, height:210, color:'blue')
    Image.new('sword.png', x:40, y:150, width:150, height:150, rotate:-10, z:10)
    Text.new('Maxhealth +20', x:27, y:300, z:10, size:15)
    Text.new('Special attribute: Iron Will', x:27, y:330,z:10, size:15)
    demon_square=Rectangle.new(x:225, y:160, width:190, height:210, color:'red')
    Image.new('Png.png', x:245, y:155, width:145, height:145, z:10)
    Text.new('Skill: Berserk', x:232, y:300, z:10, size:15)
    Text.new('Special attribute: Evil', x:232, y:330, z:10, size:15)
    devine_square=Rectangle.new(x:430, y:160, width:190, height:210, color:'green')
    Image.new('med.png',x:460, y:160, width:140, height:140, z:10)
    Text.new('Skill: Apotheosis', x:437, y:300, z:10, size:15)
    Text.new('Special attribute: Third eye', x:437, y:330, z:10, size:15)
    on :mouse_down do |event|
        if hero_square.contains?(event.x, event.y)
            character="Hero"
            gamestart=true
            maxhealth+=20
            health+=20
            clear
        elsif demon_square.contains?(event.x, event.y)
            character="Demon"
            gamestart=true
            clear
        elsif devine_square.contains?(event.x, event.y)
            character="Devine"
            gamestart=true
            clear
        end
    end
end
update do
if gamestart 
    Text.new('The ' + character, x:10, y:10, size:35,z:10)
    healthbar=Rectangle.new(x:10, y:50, color:'red',
    width:health*2, height:20, z:5)
    Rectangle.new(x:10, y:50, color:'gray', width:maxhealth*2, height:20)
    staminabar=Rectangle.new(x:10, y:75, color:'orange', 
    width:maxstamina*2, height:20)
    Text.new(health.to_s + '/' + maxhealth.to_s, x:10, y:50, color:'white',
    size:15, z:10)
end
end
show
