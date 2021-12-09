class Fighter
    def initialize(name,atk,blk,luc,spd,hp)
        @name = name
        @atk = atk
        @blk = blk
        @luc = luc
        @spd = spd
        @hp = hp
    end
    attr_accessor :atk, :blk, :luc, :spd, :hp
    attr_reader :name

    # Attack fn, to be used in combat
    def attack(opp)
        dmg = @atk/(opp.blk*0.4) 
        opp.hp -= dmg
        opp.hp = 0 if opp.hp < 0
        p "#{@name} deals #{dmg} damage to #{opp.name}, who is left with #{opp.hp} health"
    end
    # Crit fn, in event of critical hit
    def crit(opp)
        dmg = (@atk*1.5)/(opp.blk*0.4) 
        opp.hp -= dmg
        opp.hp = 0 if opp.hp < 0
        p "CRITICAL HIT: #{@name} deals #{dmg} damage to #{opp.name}, who is left with #{opp.hp} health"
    end
end

class Dojo
    # each training has varying rates of success
    # can I make this more DRY?
    # I type rand(1...5) a lot...
    def self.train_atk(ftr)
        ftr.atk += rand(1...5)
    end
    def self.train_blk(ftr)
        ftr.blk += rand(1...5)
    end
    def self.train_luc(ftr)
        ftr.luc += rand(-1...7)
    end
    def self.train_spd(ftr)
        ftr.spd += rand(1...5)
    end
    def self.train_hp(ftr)
        ftr.hp += rand(1...5)
    end
end

def game_over
    p "███▀▀▀██┼███▀▀▀███┼███▀█▄█▀███┼██▀▀▀"
    p "██┼┼┼┼██┼██┼┼┼┼┼██┼██┼┼┼█┼┼┼██┼██┼┼┼"
    p "██┼┼┼▄▄▄┼██▄▄▄▄▄██┼██┼┼┼▀┼┼┼██┼██▀▀▀"
    p "██┼┼┼┼██┼██┼┼┼┼┼██┼██┼┼┼┼┼┼┼██┼██┼┼┼"
    p "███▄▄▄██┼██┼┼┼┼┼██┼██┼┼┼┼┼┼┼██┼██▄▄▄"
    p "┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼"
    p "███▀▀▀███┼▀███┼┼██▀┼██▀▀▀┼██▀▀▀▀██▄┼"
    p "██┼┼┼┼┼██┼┼┼██┼┼██┼┼██┼┼┼┼██┼┼┼┼┼██┼"
    p "██┼┼┼┼┼██┼┼┼██┼┼██┼┼██▀▀▀┼██▄▄▄▄▄▀▀┼"
    p "██┼┼┼┼┼██┼┼┼██┼┼█▀┼┼██┼┼┼┼██┼┼┼┼┼██┼"
    p "███▄▄▄███┼┼┼─▀█▀┼┼─┼██▄▄▄┼██┼┼┼┼┼██▄"
end

def fight (p1,p2)
    # Turn counter determines when/how frequently each player attacks
    # Initialize at 0, player attacks when >10
    p1_turn = p2_turn = 0

    # Determine chance of crit, miss, or regular attack
    def check_crit(agg,opp)
        agg_chance = rand(1...agg.luc)
        opp_chance = rand(1...opp.luc)
        if agg_chance > opp_chance*5
            agg.crit(opp)
        elsif agg_chance*5 < opp_chance
            p "#{agg.name}'s attack missed"
        else
            agg.attack(opp)
        end
    end

    # Check to see both players still alive
    while p1.hp > 0 && p2.hp > 0

        # accrue turn counter
        p1_turn += p1.spd/10.00
        p2_turn += p2.spd/10.00

        # If both players clear threshold on same turn:
        # Whoever has the higher turn counter attacks
        # Simultaneous attack if turn counters are equal
        if p1_turn > 10 && p2_turn > 10
            if p1_turn == p2_turn
                p "#{p1.name} and #{p2.name} attack simultaneously."
                check_crit(p1,p2)
                check_crit(p2,p1)
                p1_turn -= 10
                p2_turn -= 10
            elsif p1_turn > p2_turn
                check_crit(p1,p2)
                p1_turn -= 10
            elsif p2_turn > p1_turn
                check_crit(p2,p1)
                p2_turn -= 10
            end
        # Player attacks when turn counter clears threshold
        elsif p1_turn > 10
            check_crit(p1,p2)
            p1_turn -= 10
        elsif p2_turn > 10
            check_crit(p2,p1)
            p2_turn -= 10
        end
    end
    
    # Check for win conditions
    if p1.hp == p2.hp
        p "It is a draw."
        return "tie"
    elsif p1.hp > p2.hp
        p "PLAYER 1 WIN: #{p1.name} is victorious"
        return "p1 win"
    elsif p2.hp > p1.hp
        p "PLAYER 2 WIN: #{p2.name} is victorious"
        return "p2 win"
    end
end

puts "*Mortal Kombat music starts playing*"
p "########################################"
puts "ENTER FIGHTER NAME:"
p "########################################"
player_name = gets.chomp

player1 = Fighter.new(
    # player name
    player_name,
    # randomized stats
    rand(20...40),
    rand(20...40),
    rand(20...40),
    rand(20...40),
    rand(20...40)
)

p "########################################"
p "WELCOME NEW FIGHTER: #{player1.name.upcase}"
p "########################################"
p "#{player1.name} stats:"
p "Attack: #{player1.atk}"
p "Block: #{player1.blk}"
p "Luck: #{player1.luc}"
p "Speed: #{player1.spd}"
p "Health: #{player1.hp}"

p "You have ten days to train for your fight"
10.times do
    p "Choose a stat to train: Attack, Block, Luck, Speed, Health"
    stat = gets.chomp
    stat = stat.downcase
    case stat
        when "attack"
            Dojo.train_atk(player1)
            p "Your ATK increases to #{player1.atk}"
        when "block"
            Dojo.train_blk(player1)
            p "Your BLK increases to #{player1.blk}"
        when "luck"
            Dojo.train_luc(player1)
            p "Your luck is now #{player1.luc}"
        when "speed"
            Dojo.train_spd(player1)
            p "Your speed increases to #{player1.spd}"
        when "health"
            Dojo.train_hp(player1)
            p "Your HP increases to #{player1.hp}"
        else
            p "You have chosen to take the day off. Most unwise..."
    end
end

p "########################################"
p "PREPARE TO FIGHT"
p "########################################"
p "#{player1.name} new stats are:"
p "Attack: #{player1.atk}"
p "Block: #{player1.blk}"
p "Luck: #{player1.luc}"
p "Speed: #{player1.spd}"
p "Health: #{player1.hp}"

initial_health = player1.hp

akuma = Fighter.new(
    "Akuma",
    rand(25...40),
    rand(25...40),
    rand(25...40),
    rand(25...40),
    rand(25...40)
)

p "########################################"
p "A CHALLENGER APPROACHES"
p "########################################"
p "Akuma"
p "Attack: #{akuma.atk}"
p "Block: #{akuma.blk}"
p "Luck: #{akuma.luc}"
p "Speed: #{akuma.spd}"
p "Health: #{akuma.hp}"

p "Do you accept the challenge?"
p "Choose accept or decline"
choice = gets.chomp
choice = choice.downcase
if choice == "decline" || choice == "no"
    p "You are weak. Begone."
    game_over
elsif choice == "accept" || choice == "yes"
    fight(player1,akuma)
else
    p "I did not understand you, please confirm."
    p "WARNING: Typing anything other than 'decline' will initiate battle"
    choice = gets.chomp
    choice = choice.downcase
    if choice == "decline"
        p "You are weak. Begone."
        game_over
    else
        fight(player1,akuma)
    end
end

if player1.hp <= 0
    p "You have been defeated"
    game_over
else
    p "You are victorious, you may advance to the next fighter or retire."
    p "Choose |advance| or |retire|"
    choice = gets.chomp
    choice = choice.downcase
    if choice = "retire"
        p "Farewell"
        game_over
    elsif choice = advance
        player1.hp = initial_health
        # This is where the fight would continue
        # Maybe for fun in the future
    else
        p "I did not understand you, please confirm"
        p "WARNING: Any response other than 'retire' will continue the tournament"
        choice = gets.chomp
        choice.downcase
        if choice = "retire"
            p "Farewell"
            game_over
        else
            player1.hp = initial_health
            # This is where the fight would continue
            # Maybe for fun in the future
        end
    end
end