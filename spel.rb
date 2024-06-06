require 'ruby2d'
set title:'spel'
$health=100
@maxhealth=100
@maxenergy=3
@energy=3
$extradmg=0
@victory=false
@deck_text=nil
@discard_text=nil
gameover=false
@battle=false
gamestart=false 
$player=nil
@m_x=480
@x=50
@y=180
@animation=nil
$playable_cards=[]
hover=nil
line=nil
select_text=nil
@level=1
$deck=[]
$discard=[]
@my_turn=false
$weak=0
$block=0
class Monster
    attr_accessor :hp, :name, :animation

    def initialize(hp, strength, name)
        @hp=hp
        @maxhp=hp
        @strength=strength
        @name=name
    end
    def battle
        mx=630-@hp*2
        @healthbar=Rectangle.new(x:mx, y:50, color:'red',
        width: @hp*2, height:25, z:5)
        @health_text=Text.new(@hp.to_s + '/' + @maxhp.to_s, x:550, y:50, color:'white',
        size:20, z:10)
        Rectangle.new(x:mx, y:50, color:'gray', width:@hp*2, height:25, z:1)
        mxt=615-@name.length*16
        Text.new(@name, x:mxt, y:8, size:35,z:10)
    end
    def heal(hp)
        @hp+=hp
        @healthbar.width=@hp*2
        @healthbar.x-=hp*2
        @health_text.remove
        @health_text=Text.new(@hp.to_s + '/' + @maxhp.to_s, x:550, y:50, color:'white',
        size:20, z:10)
    end
    def attack(damage)
        damage=damage-$block
        if damage>0
            $health-=damage.to_i
        end
        
    end
    def intent(intent)
        if intent>0
            color='red'
        elsif intent==0
            color='green'
        elsif intent<0
            color='blue'
        end
        @@intent_figure=Circle.new(x:530,y:180,radius:10, color:color)
    end
    def take_dmg(dmg)
        @hp-=dmg
        @healthbar.width=@hp*2
        @healthbar.x+=dmg*2
        @health_text.remove
        @health_text=Text.new(@hp.to_s + '/' + @maxhp.to_s, x:550, y:50, color:'white',
        size:20, z:10)
    end
end
class Werewolf<Monster
    def initialize
        super(80,6, "Werewolf")
        @actions=[1,2,3,0]
        @intent=nil
    end
    def idle
        @animation=Sprite.new('sprite/Black_werewolf/Idle.png',x:465,y:170,
        width:128,
        height:112,
        clip_width:128,
        time:200,
        loop:true,
        z:5) 
        @animation.play flip: :horizontal
    end
    def intent
        index=rand(@actions.length)
        if @hp>(@maxhp-20) and index==3
            index=rand(@actions.length-1)
        end
        @intent=@actions[index]
        super(@intent)
    end
    def action
        @animation.remove
        @@intent_figure.remove
        if @intent==1
            attack_1
        elsif @intent==2
            attack_2
        elsif @intent==3
            attack_3
        elsif @intent==0
            heal
        end
    end
    def heal
        @animation.remove
        @animation=Sprite.new('sprite/Black_werewolf/Hurt.png',x:465,y:170,
        width:128,
        height:112,
        clip_width:128,
        time:200,
        loop:true,
        z:5) 
        @animation.play flip: :horizontal
        super(15)
    end
    def attack(multiplier)
        @animation.play flip: :horizontal
        super(@strength*multiplier)
    end
    def attack_1
        @animation=Sprite.new('sprite/Black_Werewolf/Attack_1.png',x:465,y:170,
        width:128,
        height:112,
        clip_width:128,
        time:150,
        loop:false,
        z:5)
        attack(1)
    end
    def attack_2
        @animation=Sprite.new('sprite/Black_werewolf/Attack_2.png',x:465,y:170,
        width:128,
        height:112,
        clip_width:128,
        time:150,
        loop:false,
        z:5)
        attack(3)
    end
    def attack_3
        @animation.remove
        @animation=Sprite.new('sprite/Black_werewolf/Attack_3.png',x:465,y:170,
        width:128,
        height:112,
        clip_width:128,
        time:150,
        loop:false,
        z:5)
        attack(1.2)
    end
    
end
class Knight<Monster
    def initialize
        super(130,15, "Evil Knight")
        @actions=[1,2,3,-1]
        @intent=nil
        @block=0
    end
    def idle
        @animation=Sprite.new('sprite/Knight_2/Idle.png',x:485,y:180,
        width:68,
        height:86,
        clip_width:67,
        time:200,
        loop:true,
        z:5) 
        @animation.play flip: :horizontal
    end
    def intent
        index=rand(@actions.length)
        @intent=@actions[index]
        super(@intent)
    end
    def action
        @block=0
        @animation.remove
        @@intent_figure.remove
        if @intent==1
            attack_1
        elsif @intent==2
            attack_2
        elsif @intent==3
            attack_3
        elsif @intent==-1
            block(15)
        end
    end
    def attack(multiplier)
        @animation.play flip: :horizontal
        super(@strength*multiplier)
    end
    def attack_1
        @animation=Sprite.new('sprite/Knight_2/Attack 1.png',x:475,y:180,
        width:85,
        height:86,
        clip_width:85,
        time:150,
        loop:false,
        z:5)
        attack(1)
    end
    def attack_2
        @animation=Sprite.new('sprite/Knight_2/Attack 2.png',x:480,y:180,
        width:107,
        height:86,
        clip_width:107,
        time:150,
        loop:false,
        z:5)
        attack(3)
    end
    def attack_3
        @animation=Sprite.new('sprite/Knight_2/Attack 3.png',x:465,y:180,
        width:100,
        height:84,
        clip_width:100,
        time:150,
        loop:false,
        z:5)
        attack(1.2)
    end
    def block(block)
        @block+=block
        @animation=Sprite.new('sprite/Knight_2/Protect.png',x:465,y:180,
        width:86,
        height:86,
        clip_width:86,
        time:150,
        loop:false,
        z:5)
        @animation.play flip: :horizontal
    end
    def take_dmg(dmg)
        damage=dmg-@block
        if @block>0
            @animation.remove
            @animation=Sprite.new('sprite/Knight_2/Defend.png',x:460,y:170,
            width:80,
            height:86,
            clip_width:81,
            time:150,
            loop:false,
            z:5)
            @animation.play flip: :horizontal
            if damage<=0
                damage=0
                @block-=dmg
            else
                @block=0
            end
        end
        super(damage)
    end
end
def update_block(block)
    $block+=block
    Triangle.new(x1: 98,  y1: 160,
    x2: 122, y2: 197,
    x3: 74,   y3: 197,
    color:'blue')
    if $block>0
        if $block<10
            x=89
        else
            x=84
        end
        Text.new($block.to_s, x:x, y:174)
    end
end
class Skeleton_Archer<Monster
    def initialize
        super(100,10, "Skeleton Archer")
        @actions=[1,2,3]
        @intent=nil
    end
    def idle
        @animation=Sprite.new('sprite/Skeleton_Archer/Idle.png',x:460,y:160,
        width:128,
        height:112,
        clip_width:128,
        time:200,
        loop:true,
        z:5) 
        @animation.play
    end
    def intent
        index=rand(@actions.length)
        @intent=@actions[index]
        super(@intent)
    end
    def action
        @animation.remove
        @@intent_figure.remove
        if @intent==1
            attack_1
        elsif @intent==2
            attack_2
        elsif @intent==3
            attack_3
        end
    end
    def attack(multiplier)
        @animation.play flip: :horizontal
        super(@strength*multiplier)
    end
    def attack_1
        @animation=Sprite.new('sprite/Skeleton_Archer/Attack_1.png',x:460,y:160,
        width:128,
        height:112,
        clip_width:128,
        time:150,
        loop:false,
        z:5)
        attack(1)
    end
    def attack_2
        @animation=Sprite.new('sprite/Skeleton_Archer/Attack_2.png',x:460,y:160,
        width:128,
        height:112,
        clip_width:128,
        time:150,
        loop:false,
        z:5)
        attack(1.5)
    end
    def attack_3
        @animation.remove
        @animation=Sprite.new('sprite/Skeleton_Archer/Attack_3.png',x:460,y:160,
        width:128,
        height:112,
        clip_width:128,
        time:150,
        loop:false,
        z:5)
        attack(0.8)
    end
    
end
class Kitsune<Monster
    def initialize
        super(150,15, "Kitsune")
        @actions=[1,2,3]
        @intent=nil
    end
    def idle
        @animation=Sprite.new('sprite/Kitsune/Idle_2.png',x:460,y:160,
        width:128,
        height:112,
        clip_width:128,
        time:200,
        loop:true,
        z:5) 
        @animation.play flip: :horizontal
    end
    def intent
        index=rand(@actions.length)
        @intent=@actions[index]
        super(@intent)
    end
    def action
        @animation.remove
        @@intent_figure.remove
        if @intent==1
            attack_1
        elsif @intent==2
            attack_2
        elsif @intent==3
            attack_3
        end
    end
    def attack(multiplier)
        @animation.play flip: :horizontal
        super(@strength*multiplier)
    end
    def attack_1
        @animation=Sprite.new('sprite/Kitsune/Attack_1.png',x:455,y:160,
        width:128,
        height:112,
        clip_width:128,
        time:300,
        loop:false,
        z:5)
        attack(1)
    end
    def attack_2
        @animation=Sprite.new('sprite/Kitsune/Attack_2.png',x:460,y:160,
        width:128,
        height:112,
        clip_width:128,
        time:150,
        loop:false,
        z:5)
        attack(3)
    end
    def attack_3
        @animation.remove
        @animation=Sprite.new('sprite/Kitsune/Attack_3.png',x:460,y:160,
        width:128,
        height:112,
        clip_width:128,
        time:150,
        loop:false,
        z:5)
        attack(2)
    end
end
class Yamabushi<Monster
    def initialize
        super(100,8, "Yamabushi tengu")
        @actions=[1,2,3,0]
        @intent=nil
    end
    def idle
        @animation=Sprite.new('sprite/Yamabushi_tengu/Idle.png',x:460,y:170,
        width:128,
        height:112,
        clip_width:128,
        time:200,
        loop:true,
        z:5) 
        @animation.play flip: :horizontal
    end
    def intent
        index=rand(@actions.length)
        @intent=@actions[index]
        super(@intent)
    end
    def action
        if $weak>0
            $weak-=1
        end
        @animation.remove
        @@intent_figure.remove
        if @intent==1
            attack_1
        elsif @intent==2
            attack_2
        elsif @intent==3
            attack_3
        elsif @intent==0
            debuff
        end

    end
    def attack(multiplier)
        @animation.play flip: :horizontal
        super(@strength*multiplier)
    end
    def attack_1
        @animation=Sprite.new('sprite/Yamabushi_tengu/Attack_1.png',x:460,y:170,
        width:128,
        height:112,
        clip_width:128,
        time:150,
        loop:false,
        z:5)
        attack(1)
    end
    def attack_2
        @animation=Sprite.new('sprite/Yamabushi_tengu/Attack_2.png',x:460,y:170,
        width:128,
        height:112,
        clip_width:128,
        time:150,
        loop:false,
        z:5)
        attack(1.5)
    end
    def attack_3
        @animation.remove
        @animation=Sprite.new('sprite/Yamabushi_tengu/Attack_3.png',x:460,y:170,
        width:128,
        height:112,
        clip_width:128,
        time:150,
        loop:false,
        z:5)
        attack(0.8)
    end
    def debuff
        @animation=Sprite.new('sprite/Yamabushi_tengu/Hurt.png',x:460,y:170,
        width:128,
        height:112,
        clip_width:128,
        time:150,
        loop:true,
        z:5)
        @animation.play flip: :horizontal
        $weak+=2
    end
    
end
@monsters=[Werewolf.new, Skeleton_Archer.new, Knight.new, Yamabushi.new, Kitsune.new]
def victory_screen
    discard_all
    clear
    while $deck[0]!=nil
        $discard<<$deck[0]
        $deck.shift
    end
    shuffle
    if $player=="Demon"
        $extradmg+=1
    end
    @victory=true
    @battle=false
    @my_turn=false
    if $Monster.name=="Kitsune"
        Text.new("Victory", x:240, y:200, size:50, color:'yellow')
    else
        Text.new("Victory", x:260, y:100, size:40, color:'yellow')
        Text.new("Choose Card:", x:258, y:170, size:20)
        cards=[]
        $available_cards=[]
        if @level<=3
            temp=5
        else
            temp=3
        end
        i=0
        while i<3
            r=rand(temp)
            if r==1
                cards=$rarecards
               text="rare"
            else
                cards=$commoncards
                text="common"
            end
            r=rand(cards.length)
            $available_cards<<cards[r].dup
            $available_cards[i].option(i+1, text)
            i+=1
        end
    end
end
class Empty_card
    attr_reader :cost

    def initialize
        @cost=10
    end
end
class Card
    attr_reader :cost, :name, :card, :hovering, :box

    def initialize(cost, name, description)
        @cost=cost
        @name=name
        @description=description
        @hovering=false
        if $player=='Hero'
            @@color='red'
        elsif $player=='Demon'
            @@color='purple'
        else
            @@color='orange'
        end  
    end

    def draw(index)
        @card=Rectangle.new(x:(458-index*132), y:380, width:120, height:200, color:@@color)
        x=498-@name.length*3.7
        @name_text=Text.new(@name,x:(x-index*132), y:430, size:30)
        x=518-@description.length*3.7
        @cardtext=Text.new(@description, x:(x-index*132), y:480, size:15)
        @cost_text=Text.new(@cost, x:510-index*132, y:385, size:30)
    end
    def option(index, rarity)
        @box=Rectangle.new(x:index*170-100, y:295, width:160, height:110, color:'white')
        Text.new(@name,x:index*170-90, y:300, z:10, size:15, color:'black')
        Text.new(@description,x:index*170-90, y:325,z:10, size:15, color:'black')
        Text.new(rarity,x:index*170-90, y:350,z:10, size:15, color:'black')
        Text.new("cost #{@cost}",x:index*170-90, y:375,z:10, size:15, color:'black')
    end
    def hover
        @card.y=320
        @name_text.y=370
        @cardtext.y=430
        @cost_text.y=325
        @hovering=true
    end
    def unhover
        @card.y=380
        @name_text.y=430
        @cardtext.y=480
        @cost_text.y=385
        @hovering=false     
    end
    def discard
        @card.remove
        @name_text.remove
        @cardtext.remove
        @cost_text.remove
    end
    def attack(dmg)
        $Monster.take_dmg(dmg)
    end
    def block(block)
        update_block(block)
    end
end
class Stab<Card
    def initialize
        @dmg=25
        super(2, "Stab", "Deal #{@dmg+$extradmg} damage")
    end
    def play
        attack
    end
    def attack
        damage=@dmg+$extradmg
        if $weak>0 && $player!="Hero"
            damage=damage/2
        end
        super(damage)
    end
end
class Swing<Card
    def initialize
        @dmg=15
        super(1, "Swing", "Deal #{@dmg+$extradmg} damage")
    end
    def play
        attack
    end
    def attack
        damage=@dmg+$extradmg
        if $weak>0 && $player!="Hero"
            damage=damage/2
        end
        super(damage)
    end
end
class Execute<Card
    def initialize
        @dmg=40
        super(3, "Execute", "Deal #{@dmg+$extradmg} damage")
    end
    def play
        attack
    end
    def attack
        damage=@dmg+$extradmg
        if $weak>0 && $player!="Hero"
            damage=damage/2
        end
        super(damage)
    end
end
class Harden<Card
    def initialize
        @block=10
        super(0, "Block", "Gain #{@block} block" )
    end
    def play
        block
    end
    def block
        super(@block)
    end
end
class Jab<Card
    def initialize
        @dmg=10
        super(0, "Jab", "Deal #{@dmg+$extradmg} damage")
    end
    def play
        attack
    end
    def attack
        damage=@dmg+$extradmg
        if $weak>0 && $player!="Hero"
            damage=damage/2
        end
        super(damage)
    end
end
class Link<Card
    def initialize
        @dmg=7
        @block=7
        super(1, "Link", "Damage: #{@dmg+$extradmg} Block: 7")
    end
    def play
        attack
        block
    end
    def attack
        damage=@dmg+$extradmg
        if $weak>0 && $player!="Hero"
            damage=damage/2
        end
        super(damage)
    end
    def block
        super(@block)
    end
end
def play_card(card)
    card.play
    update_energy(card.cost)
    $discard << card
    update_deck
    card.discard
end
def gameover
    close
end 
def update_energy(cost)
    @energy-=cost
    @energybar.width=@energy*20
    @Energy_text.remove
    @Energy_text=Text.new(@energy.to_s + '/' + @maxenergy.to_s, x:12, y:80, color:'white',
    size:20, z:10)
end
def update_health
    if $health<=0
        gameover
    end
    @healthbar.width=$health*2
    @health_text.remove
    @health_text=Text.new($health.to_s + '/' + @maxhealth.to_s, x:12, y:50, color:'white',
    size:20, z:10)
end
def generate_monster
    return @monsters[@level-2].dup
end
class Basic_attack<Card

    def initialize
        if $player=="Hero"
            name="Strike"
        elsif $player=="Demon"
            name="Chop"
        else 
            name=""
        end
        super(1, name, "Deal #{10+$extradmg} damage")
        @dmg=10
    end
    def play
        attack
    end
    def attack
        damage=@dmg+$extradmg
        if $weak>0 && $player!="Hero"
            damage=damage/2
        end
        super(damage)
    end
end
class Basic_block<Card 
    def initialize
        @block=10
        super(1, "Block", "Gain #{@block} block" )
    end
    def play
        block
    end
    def block
        super(@block)
    end
end
def shuffle
    $deck=$discard.shuffle
    $discard.clear
end
def discard_all
    i=0
    while i<=3
        if $playable_cards[0].cost==10
            $playable_cards.shift
        else
            card=$playable_cards[0]
            $discard<<card
            card.discard
            $playable_cards.shift
        end
        i+=1
    end
end
def draw
    $playable_cards=[]
    i=0
    while i<=3
        if $deck[0]==nil
            shuffle
        end
        $deck[0].draw(i)
        $playable_cards<<$deck[0]
        $deck.shift
        update_deck
        i+=1
    end 
    @my_turn=true
end
def Apotheosis()
end
def start_turn
    $block=0
    update_block(0)
    @energy=3
    update_energy(0)
    draw
    $Monster.intent
end
def start_battle
    $Monster=generate_monster
    $Monster.battle
    $Monster.idle
    $Monster.intent
    @character.width=96
    @character.height=108
    @character.y=@y
    Rectangle.new(x:10, y:420, width:40, height:50, color:'yellow', z:5)
    Rectangle.new(x:590, y:420, width:40, height:50, color:'gray', z:5)
    draw
    update_deck
    @battle=true
end
def update_deck
    if @deck_text!=nil
        @deck_text.remove
        @discard_text.remove
    end
    @deck_text=Text.new($deck.length.to_s, x:22, y:428, size:30, z:10, color:'black')
    @discard_text=Text.new($discard.length.to_s, x:602, y:428, size:30, z:10, color:'black')
    if $deck.length>9
        @deck_text.x=12
    end
    if $discard.length>9
        @discard_text.x=592
    end
end
def start
    clear
    @energy=3
    @nextlevel=Rectangle.new(x:360, y:320, width:180, height:50, color:'white')
    @nextleveltext=Text.new('level ' + @level.to_s + ' -->', x:370, y:328, size:30, color:'black')
    Text.new('The ' + $player, x:10, y:8, size:35,z:10)
    @healthbar=Rectangle.new(x:10, y:50, color:'red',
    width:$health*2, height:25, z:5)
    Rectangle.new(x:10, y:50, color:'gray', width:@maxhealth*2, height:25)
    @energybar=Rectangle.new(x:10, y:80, color:'blue', 
    width:@energy*20, height:25, z:5)
    @health_text=Text.new($health.to_s + '/' + @maxhealth.to_s, x:12, y:50, color:'white',
    size:20, z:10)
    @Energy_text=Text.new(@energy.to_s + '/' + @maxenergy.to_s, x:12, y:80, color:'white',
    size:20, z:10)
    Rectangle.new(x:10, y:80, color:'gray', width:@maxenergy*20, height:25)
    @character=Sprite.new(
        @walk,x:@x,y:@y+20,
        width:128,
        height:144,
        clip_width:64,
        time:200,
        loop:false
    )
end
if gamestart==false
    Text.new('Choose Character', x:170, y:55, size:35)
    hero_square=Rectangle.new(x:20, y:160, width:190, height:210, color:'blue')
    Image.new('img/sword.png', x:40, y:150, width:150, height:150, rotate:-10, z:10)
    Text.new('Maxhealth +20', x:27, y:300, z:10, size:15)
    Text.new('Special attribute: Iron Will', x:27, y:330,z:10, size:15)
    demon_square=Rectangle.new(x:225, y:160, width:190, height:210, color:'red')
    Image.new('img/Png.png', x:245, y:155, width:145, height:145, z:10)
    Text.new('Skill: Berserk', x:232, y:300, z:10, size:15)
    Text.new('Special attribute: bloodlust', x:232, y:330, z:10, size:15)
    soothsayer_square=Rectangle.new(x:430, y:160, width:190, height:210, color:'green')
    Image.new('img/med.png',x:460, y:160, width:140, height:140, z:10)
    Text.new('Skill: Apotheosis', x:437, y:300, z:10, size:15)
    Text.new('Special attribute: Third eye', x:437, y:330, z:10, size:15)
    on :mouse_down do |event|
        if gamestart==false
            if hero_square.contains?(event.x, event.y)
                hover="Hero"
                @square=hero_square
            elsif demon_square.contains?(event.x, event.y)
                hover="Demon"
                @square=demon_square
            elsif soothsayer_square.contains?(event.x, event.y)
                hover="Soothsayer"
                @square=soothsayer_square
            end
        end
    end
end
update do
    if gamestart==false
        if hover!=nil
            if line !=nil
             line.remove
             select_text.remove
            end
            x=@square.x
            y=@square.y+210
            line=Line.new(x1:x, y1:y, x2:x+190, y2:y, width:10,color:'white',z:10)
            select_text=Text.new('press "Enter"',x:255,y:400,size:20,z:5,color:'white')
        end
    end
    if gamestart
        if @battle==false
            on :mouse_down do |event|
                if @battle==false && @victory==false
                    if @nextlevel.contains?(event.x, event.y)
                            @nextlevel.remove
                            @nextleveltext.remove
                            @character.play
                            @level+=1
                            start_battle
                    end
                elsif @victory==true 
                    i=0
                    while i<3
                        if $available_cards[i].box.contains?(event.x, event.y)  
                            @victory=false  
                            $deck<<$available_cards[i]
                            start
                        end
                        i+=1
                    end
                end
            end
        elsif @battle && @my_turn         
            i=0
            x=get :mouse_x
            y=get :mouse_y
            while i<4
                tempcard=$playable_cards[i]
                if tempcard.cost!=10
                    if tempcard.card.contains?(x,y)
                        if tempcard.hovering==false
                            tempcard.hover
                        end 
                    else
                        if tempcard.hovering==true
                        tempcard.unhover
                        end
                    end
                end
                i+=1
            end             
        end
    end
end
on :key_down do |event|
    if gamestart==false
        if hover!=nil
            case event.key
            when 'return'
                $player=hover
                if $player=="Hero"
                    @maxhealth+=20
                    $health+=20
                    @attack_ani='sprite/attack.png'
                    @walk='sprite/walking-sprite-hero.png'
                    $commoncards=[Stab.new, Link.new]
                    $rarecards=[Jab.new]
                elsif  $player=="Demon"
                    @walk='sprite/demon.png'
                    $commoncards=[Harden.new, Swing.new]
                    $rarecards=[Execute.new]
                end
                gamestart=true
                start
                i=0
                while i<=4
                    $deck << Basic_attack.new
                    $deck << Basic_block.new
                    i+=1
                end
                $deck << Basic_attack.new
                $deck=$deck.shuffle
            end
        end
    elsif @my_turn
        case event.key
        when '1'
            if $playable_cards[3].cost<=@energy 
                play_card($playable_cards[3])
                $playable_cards[3]=Empty_card.new
                if $Monster.hp<=0
                    victory_screen
                end
            end
        when '2'
            if $playable_cards[2].cost<=@energy 
                play_card($playable_cards[2])
                $playable_cards[2]=Empty_card.new
                if $Monster.hp<=0
                    victory_screen
                end
            end
        when '3'
            if $playable_cards[1].cost<=@energy 
                play_card($playable_cards[1])
                $playable_cards[1]=Empty_card.new
                if $Monster.hp<=0
                    victory_screen
                end
            end
        when '4'
            if $playable_cards[0].cost<=@energy 
                play_card($playable_cards[0])
                $playable_cards[0]=Empty_card.new
                if $Monster.hp<=0
                    victory_screen
                end
            end
        when 'return'
            discard_all
            @my_turn=false
            $Monster.action
            update_health
            start_turn
        end

    end
end
show
