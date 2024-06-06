require 'ruby2d'
$player=='Hero'
$extradmg=0
class Card
    attr_reader :cost, :name,

    def initialize(cost, name, description)
        @cost=cost
        @name=name
        @description=description
        if $player=='Hero'
            @@color='red'
        elsif $player=='Demon'
            @@color='purple'
        else
            @@color='orange'
        end  
    end

    def draw(index)
        @card=Rectangle.new(x:(580-index*120), y:400, width:110, height:200, color:@@color)
        x=600-@name.length/2
        @name=Text.new(@name,x:(x-index*120), y:390, size:30)
        x=600-@description.length/2
        @cardtext=Text.new(description, x:(x-index*160), y:420, size:20)
    end
    def hover
        @card.y=340
        @name=Text.new(@name,x:(x-index*120), y:330, size:30)
        @cardtext=Text.new(description, x:(x-index*160), y:380, size:20)
    end
    def discard
        @card.remove
        @name.remove
        @cardtext.remove
    end
    def attack(dmg)
        damage=dmg+$extradmg
        $Monster.hp=$Monster.hp-damage
        discard
    end
    def block(block)
        $block+=block
        discard
    end
end
def discard_card(card)
    $discard >>card
    card.discard
end

class Basic_attack<Card
    attr_reader :dmg

    def initialize
        if $player=="Hero"
            name="strike"
        elsif $player=="Demon"
            name="chop"
        else 
            name=""
        end
        super(1, name, "deal #{10+$extradmg} damage" )
    end
    def attack
        super(10)
    end
end

 Basic_attack.new