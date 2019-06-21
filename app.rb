require 'watir'
require 'webdrivers'
require 'time'
require 'rake-progressbar'

def time_stamped_file(file)
    file.gsub(/\./,"_" + Time.now.strftime("%Y%m%d%H%M%S") + '.') 
end  
f = "log.txt"  
log_file = File.open("#{File.dirname(__FILE__)}/log/#{time_stamped_file(f)}" , 'w')


profile = Selenium::WebDriver::Firefox::Profile.new
profile['permissions.default.image'] = 2

browser =  Watir::Browser.new :firefox, headless: true, profile: profile
hora_inicio_script = Time.now

if ARGV[0].to_i < 1
    ARGV[0] = 1
end   
    
total_votos = ARGV[0].to_i 
system("clear")
puts "-------------- Iniciando Votação --------------"
puts Time.now
puts "-----------------------------------------------"
browser.goto 'url'

bar = RakeProgressbar.new(total_votos)
log = []
count_erro = 0

total_votos.times do |i|
    begin
        hora_inicio = Time.now
        
        browser.execute_script('document.getElementById("poll-answer-110").checked = true')
        browser.execute_script('poll_vote(21)')
        browser.refresh   
        hora_fim = Time.now
        tempo_gasto = (hora_fim - hora_inicio)
        log << "#{i+1}/#{total_votos} - concluído em #{"%.2g" % tempo_gasto}s"   
    rescue
        log << "#{i+1}/#{total_votos} - ocorreu um erro..."
        count_erro += 1
    end
    bar.inc
end

bar.finished
browser.close

hora_fim_script = Time.now
tempo_gasto_script = hora_fim_script - hora_inicio_script
puts ""
puts "+------------- Script Finalizado--------------"
puts ">> Total de votos realizados:  #{total_votos - count_erro} "
puts ">> Tempo do script: #{"%.2g" % tempo_gasto_script}s"
puts ""
puts "+---------------- Log ------------------------"
    log.each do |l|
        puts l
    end
puts "+---------------- End Log --------------------"
puts ""

log_file.puts(log)
log_file.close