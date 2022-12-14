namespace :dev do
  desc "Configura o ambiente de desenvolvimento"
  task setup: :environment do
    if Rails.env.development?
      show_spinner ("Apagando BD...") { %x(rails db:drop) }      
      show_spinner ("Criando BD...") { %x(rails db:create) }      
      show_spinner ("Migrando BD...") { %x(rails db:migrate) }
      %x(rails dev:add_mining_types) 
      %x(rails dev:add_coins)
    else
      puts "Voçê não está em ambiente de desenvolvimento" 
    end
  end
  desc "Cadastra as moedas"
  task add_coins: :environment do
    show_spinner ("Cadastrando moedas...") do
      coins = [
              {
              description: "Bitcoin" ,
              acronym:  "BTC" ,
              url_image: "https://icon2.cleanpng.com/20180729/zxh/kisspng-bitcoin-cash-cryptocurrency-bitcoin-unlimited-logo-bitcoin-white-5b5e786f87c2d5.4634025615329178715561.jpg" ,
              mining_type: MiningType.find_by(acronym: 'PoW')
              },
              {
              description: "Ethereum" ,
              acronym: "ETH" ,
              url_image:"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAHcAAAB3CAMAAAAO5y+4AAAAY1BMVEX///8zMzOMjIwUFBQ4ODgsLCyQkJBmZmYoKCgREREAAACHh4eEhIQwMDD4+PgeHh4jIyPk5OQZGRmsrKydnZ20tLTQ0NDIyMjx8fF8fHxYWFhCQkLCwsLe3t5eXl5NTU1ycnIxnOdeAAAEtElEQVRoge2b3XqjIBCGC/4CoqjEmJhE7/8qV40RRDSJgt2Dfqfdp+8yfsDMMP35+dOf/i/l8a9gi/r0G9jYD9zyF7gnGGTweGxK/MBL7odzecf16qOxRQRbLkiOthaBPZcmx+6l08AFjByJTSM4cAE60locjlzvcRy2iAQXoMOsFUMocSk96tTqTCW4gEXHYHtTSVyQFYdwOVG4x1jrPCxXcEGS28eWPpxxaWXfWoOpJtwDrJWOWJkLEtvW4nqu7QtxNJXCtWytWMJOuQDZvBBzssgNL/awqbxchQuwPWtxuMKlV1vYIlrjAseStUoIV7m2LsQTWedaOrWmptJx7ZxaHL7lehasdVaXq+GCzLi1VFPpudRLDXNz8gkXhI1Z7H2O1XIBOxvlzky1xPUqk9izZrl6Lki4OWyswy5wQWbu1NKYaplrzlrpRYdd4pq7EH0t1b9UoZZLDVlrflJ11KaiIcr0X9iItUrNiQEbF7huiBzk6NbMTJxaM1P50aOj9lynJTM6s5aBXOuuJBn+ZaAOXC05231qxVyhXl/UkdspmX5or96b1d7kRB02NRipE66jWGyvtcoJtaKuLJnbkSWLUbrPWqOpfBK4U6rK7T+0sFazB/u6/loLywFe4LZkxKj7BCd7rOUPZqrpnKrjdujkaW7qbsfeyHAy6agL3NFibLO1yqj7rJUeusx9WQxttVbuRyvUFe7zLPGCbdi7fEZ8ye3ICb5t4sJE3TjfcFsybrYt+FaF27kIs80N09hna0te42IM9xzRaeAsf+JlLsLXvVdwUSXfchH2tjlqqpx5X3ExNpRClxd9sLVcjJsxgd72hQvxYlFcmYas4SJcifvgvNHQPBf/81yzp2bcdu/wcY3lZWvvMI7gefw1KfHe3b8YX0YXxznFmwuWexTxSbDXuAjXolA411m2452lTTciEeyfE/UWuRgLTto4lDXbsf3FTyKxGWPi6PO6NsTCvByFbbGyK6Ps29wREcFOH9k8j21DLP7FLeyyrL0tpWceG3ER7FvFptzWxSIi94dDjZRIzwY7iU5j3GIeehIXY1/sHfhM4MP9LzuvDJr4InJpk4CBi3AgboCTy4xkz73GLmzExW8716zjIgxEiIvHkEqCPVtIaOyHToMNvBA7UoijsUZiZlrvsaj3CZSCfUFSiHM61grU1FiH3ImVgy0fZUiUouYa/nJRODnAniovSCoGmW8KO3mtmh5g/Q/lQtBsw07pcRAoQnymiVz40sRoR7ZQmhyvYKdBNu0xmH43U7srhNzin5KHSjtn3y2kUTlrnhF+qtmUam4LCc070P5j1rvaVWwvSH3G0b2nGNxCo2K19z3jelcrb6LqA9KMm1ka1XnzPoisPT1PN5PCDTeW9x8oXuFSZnGW4r78zo4tbCEheTNNuLYnOHw91+yzkUYLcyPM+kiSyAEkrsnHqiWNOYDgGkiX36ucrddIuvxed3XezDHRRflAynxdctB83Suhfs0T7qs4v1Eqz08eNNXX6ybmVM08yn0q/prLtTE6saJuEKvnooNH3Ie5azMV5zfKuzlz02MTn8j3g9D9hb+cuMPgyC0kdKttpMsfiP/O36f86U+L+ge9hUzq5tOmAgAAAABJRU5ErkJggg==" ,
              mining_type: MiningType.all.sample
              },
              {
              description: "Dash" ,
              acronym: "DASH" ,
              url_image:"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAHoAAAB6CAMAAABHh7fWAAAAYFBMVEUlc8L///8Far+twuMecMH6+/1Xi8sAaL4SbcCCptaNrdksdcMAZb3l7PYAYrw7fcbu8vl6oNRMhcnX4fG8zuhhks1xm9Kzx+XH1utols81ecSUsNrQ3O6gut/f5/MAXbsZg9rhAAAEl0lEQVRogcWb23aDIBBFUVGJJt5TE7Xp//9l0dydGRAx4Ty1q1nd4QDDMADzjBXWTdCXxyrvGOvy6lj2QVOH5v+HmVGH4CcVwvcF55xNkj+Mv4v0JxjM+AboQ3PuRCwYIfmn7twctkcX7ZHtOYW9i+/ZsS02Rdclj7XcGz3mZb0Zuoky0mbU+ixqNkG3qd5oaHzaWqMb7ptyr/K5ruVqdB35xi1+tDyO1H2uQoeJMOrjuYRIVDNdgR7ylV4/5efDGnSfrfb6KZ71xuiiiu3Bo+KKCjEE+rR+eM3F/ZMJOtiOPLKD5ehkI7PvipOl6HJjsmSXy9Dbk3E2RH+CjLIB+jNkjD1Hbz3CXtjzsTZDBx8jS3agQp+so7ZKs9jyhi62jCRQ3C9IdPVRsmRXFLr/YEdfFfc4esg+TWYsGzB0mH/Y7lE8DxF08tHRfZefQHRtlYYtl6gBOvoWOpqjm6/YPcpvZmj+hTF2Fefv6PZrjZbNbt/Q6ffIjKWv6Gb/TfS+eUFHup4W/jqh04ZHT3StC6EiCdZpx7DFMKsf6FI3p/feap0qOIJFeUcXWruxXHaxesjmxQ3d6hZLauuyUNDUuL2hj9pwsqIg96IDbPXxioZ/mUn8WJHRsXSY0NpJHdv5LQmgR8epzRb43S0twlE6gMk7Os68sNOQrf32CuhrF0r0oJ3Utn7LJBu2Z5Bo7YYjt/XbK2C0lFsR5v1oWi3jSWioOfoEDZe9yLTrJa8iM1Wgg0pkIKceC/U5GTdTNm91gQ1kEbLNM9EpUun8HjNTtnk+6IOaMDqa/IYFW6P5fEIUOfoNA9ZThguVFORo3mh80y56ho2+SX1Ca0fH3hj4vcOzpJIREVzssNhwlyp3Bmc+eKDmR0Zs54WimqyqAUC/iUDNK4aOAbkZVZEvJn5TgylnuB3+rwqtmBUc+E19klow+WWl3yCeXAwnL+yxVxX0Wgfrz7/0RETbDXtsod97sMCSZZIOH2YgIr2J3ibxCCwdf9Rnc3Ry8bOKHJL/DRmdv5RDcnJhIWWvnNQKv/+AW2TOKUMKFkjFTiU8ElxbMicjqdH9syW+fCiXDjqeCOA3vaeSy8eWi2YG4smZ/J5y0dw0VQB+0w7JVGHDBAn6rdhTyQRJkRYapoPcB4fGtN9jWkgnw51hEhyB6FsoEu1UsQWQ9tmm/mQ8uW0BqI0PHK6mQvPvm6aND5VFKJOFRUKKKM9WD/QmV50sLNFBtY+cNrlEmI1t/Q5VFd/r1h6ffNZ+h8rjo1tBAy3j2PpdaEr7B7p4pU7OtLpUSvK9eIUtL5Z+t5rK/qNkhwR5K78vka4c9ihUIiU1C78vu79lNVeiKJ2vLEL3Z8U9vIdeitJIjrm29L7k9Oa1FO/yAMLhsYvLwyaHR2xfPFiM5weLDo9TXR4iOzw6d3lhwOE1CZeXQ1xeiXF5Ecjh9SeXl75cXnVzecHP5bVGl5c5XV5hdXlx1+V1ZZeXtF1eTfccXsj3XD5DcPn4wrN8cuJbPDkZ5eyhzShnz4umlrt6VDXK2VOyUc4e0E1y9WzwKlePJR/8xxPRNLV5IvoPUZBJIvL7Kr4AAAAASUVORK5CYII=" ,
              mining_type: MiningType.all.sample
              },
              {
              description: "IOTA" ,
              acronym: "IOT" ,
              url_image:"data:image/png;base64,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" ,
              mining_type: MiningType.all.sample
              },
              {
              description: "Zcash" ,
              acronym: "ZEC" ,
              url_image:"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAMgAAADICAMAAACahl6sAAAAb1BMVEXsskT////ss0X++vT//vzssUHzt0brs0jrrzzrrz/vtEX99OPvwGb12KH6vEjtuFL67NHzzYXwxHDqqzT99ur44bX55L7+v0nuulr33Kz005Tz0Ivyyn7558b78dzxxXT226b01JnvvWD6wVjuv2nWq6v7AAAMYElEQVR4nOWda3fyrBKGgSAoKokxMSePefr/f+OGxKrVBBMYTN/u+0O72tWGXA6HAYYBYUDR6zcaJMddUW72qzoPCVISPK/jU3UpDlEQUPrjz2GEgJ5zfTmFEBVlnAsmtNCjmt8wxnhcFlESANPAgDRvQ5NjWq2YZOwKQAj6KdJ+UTQZrzfFMQlu/+wsAJDmRZQhqlxmTBCu3v+Z4BlI/ZFgUuZVGiW3R7jJFaSpUsvDJRaZRJy/GKGfhXCOZEbi9WGJb1VzKhBderK76PqkP+WBEHca9S8sY3G5S5xRXEBUyTRan4SiGA/xAMOUXc4H7FbDrEH0B0jTfZ5JB4obi5ThPk1cUGxBVInLMuYZUzUdQKrxZ3y1dkCxtsiyypkUrsa4i3AhRV0ebVEsQZJKjXnvetnRLIiJvFzavZEVSFKGCBwDNSMoQ3mZfAiErrkqz5uECAuL2jUahB5qJt6/jhMKC3d0bFsZC3Lc+8ZoUTZjW/0IEPXc5MzZYC/ERYTx87imMhxEcUQnH028m4Rkq2iMUQaDUBycufwQhibhkqsBcjDJQBDlkER7hkBG8cEoJIujwb7kMBD1sDSUcMP4QHGZp8MwBoKoarVRrfzDGJqE8U0wrHoNs0gUSzEBh6peQsbHQa84AITiXfjBVv6MIvPdEJsMsUgxSbW6kbBwSEN5D0Ir4dGzGiLBK/rWKG9A1AM2E2Nosc1bEjOI6q72v4BDk7zrvIwgmmO6Zv4oIvdvSEwgDcdHB/N+8XckBpDfxPGexGSR38RxJbECCU6/iUOTnAwk/SB08zva+V2qxffXrT4QqsaPX2UPLa7Hk7EWqaZ0S/pEWDUWJCUfWGMYL4GKnq6rE0T7u+4D+qxDzg9lvMcX7gJR09rcmWPGq/WL9twZhYVRJ0kHiPLPYvcOa6EKfNHOHYTIuNOB7AJRHa9rcS3IU3kUAgQhuelakHgFoTTlAPNabyBE8LSD5AVENZAQouf1ZxHS2UyeQShOYhDPxB9I66s8k7yA0EsGMqJ7BCGcnV8qF3ouK/oHs0rtEUQ1k38vXeKzRZIVkKvoE0RVrvi5cj1b5AxTsTyDKPfxeVfrCeQ4PAjjjfyCIMGfFiB/gijfHcrn9QxC2N5UtXZwvrtnEEVy6AehIZzv7h1E1LQXpABcjPMNovzgdR9IYmsQ8io+6wQJEe+UTamCJ7QLhOLSkmM279CWd4Cki223rAwlyocS0L2UZW4HMgtXHarj4ytIVG26FdqQsDDpAMHKIFYgfLtfdmrMfv/X3Ka7FNX9s/oGofSY2/W9fLsZ/L60TysrEBYuX0FsDaIt0v1yw+1BsR0IYneT3KpWUlsOhtoijiGi9iD58QmE4rVtsAwIyNfWCoTIW8f1bRF79x0EJLYFubnz6PqklNt6J1OCqEEx/QlC99bzkElBeLZ/rFoUH0LrFSAQkM3crnDC8qsDcQU5S+sJ1aQgyiTrO4jbEtDEIPLUBnW1IDuHAL9pQdS8ZHcDwbR0WHIAAdlbg3C5/q5aqmZ9OUxxYSyysC2esNVSl9+AHFy2C0FATnYuigbRk3d6rVrrzGHNYdJxRJPIS9tGdJ/lsngC42tZWwRxFut+S4McnaIuAUBwUNuDEM6iBgTj1KVmAYCoWbYDiBoTC9w29sppQ2TMDLEP5BBa91q6A67axp7kTjttaoYYDFG/1dRkyKF8NSTmiQJRTcR1h2q2eK9t/bKocgehDp0W0iZRz1YWKZy32joW6H4I8UXevTveGiR1ewEu06b7hVuB79WMpAaO5GvrREJYpXutoPYfZE3OBo7gNHezCBGrQIEk/mP35+v+DprSiyOHJkkUSAS12dZbzHxv4MAFdz5cw2WkQM6+m8g8Nh0ySvnMuXzCzqr7Lf2CkNnKcESSpmTmXiEIKymisd8IM8L7BxCMlxyAAyERUxT4bSFkZjpqkKwWENWBoDxAgdeaZebAewcX60cxIkGRzyB+vr2YOM5gO4rsiA4eQfj81H8AT3kmCAxE7FDhr63z+dfSwLHkQBVLSRTo4g9kwQ8mjhqOA4kSVb5A1ABhOOVFqf1SVkdZYoNO3ixi9rDWkN0+EXvkbTycbRKDh5XO3D2TB4kVqgEf9yAy++r3sHQAqLPL+1M1ykGfd9MsNExtdUMHdihyXweiDR0WxsEG2B4IhchPE5n3HSpoLFKCeFg/5MnPmlemJbvUYTXuo1JTQtOxrggyaMuniG7o/VpaRQJNoCbkrF/ByRMHfHWd7wwctAL0TB4kVL8FK7K49AcGUVwAeoqP4tADIlcNvReE4oOvhp4Duyh8YVqsVp6Jr4ZeoxXkiMjnPUe5Wo7kC34kbCVitAdc+SWzWf9iNaaB/Sb0O4kT2gCCzMja1NAvc2+Zh0SFbIN9u7QwHApuwrC9uSbiArn4sKhNU5Cd+2J1v0SBdmAgs7B/kVdNQb7AXfcHsQM6wq1rGRdHXXdzzGIRSqAa++Js4MCl2+7aGxEWoCAHqbp6N8eg1Ks91AAWAG0r8IVhF0Q1dH/9VSO9rQCy0cNn3JTwcgntmT6p2eiB2HpTHKlhbruMvY3orZqtNxy5xwvMuNEziX3P0XmmN0MTZ4vwmWlxFJfe1xoI19vTwcqxA9ZTEIPLC7eb0yciah0wQB0Th/Dtl2k35wyQseKNiE6XglQf79hIDA2Ettvo74JuHKselwVAmBPZxqapbbgdEgTl1qt9hzk5Bp4hQ0tXXdYgFS5T+WvgmWso4CI0LVcPVOoCcgsFxIVDWA2Z1/0bngNF3UBIpt1uHS4bMYf89fPatM77EZAmSERbJIntQ8rJ/Mu5ZrmBkO8AZvWgi32eB9VpTQ2SNaeor0H+1l05mZ8mBuG3IH81n17ZD+4L94ByJxDCWseiPQiztu+ATXF+nwDhWflwxmpnPyTOp7UIIex+NInixD6T4cQgXMb3w2I6ON16TJwWhBB5/nEOMbI8zD45iPj2kL5PT9secZ14HNFHXGEOHU8M8nLoGAeW+fOmBSFy9b1ufjuYX9qCTOlrCXabDN1yPhztUjOS+Wo6EMLuGxn35BWVPchwkp4kHJYg4iHFyz3By9Iq66cGcZcdCNG5K15BsFWYpgIZcTos6U4FszxbgWiD3PSQOyixMsmMx5362nek3Cm6kvMo5VYdjcgfZtnuSZBm264cSN1JkNaLzr+d2y0HdSdB0iaxGxQ7l9y601KlvGexzoojfNx7/ZEobP3fShRW4D4QCngArhPE6Sjrk0TYn7pNT96hyukEieBA9ISqH4Se/KY3hAMhzwnLXxJOQsUPdIIcoUAIMSecxLSAyhbfAaLXy4FAeHY2pgBt3HkYkk6QIIeJaHxw33ssgnH0D6bn6gShNQgIIf9eHv6auPjssKT9oC4QCgTCs9cA0NdU0kCXXHSCYBCQ2xKQsWp5TO6tfoYIHdDe+2ut/WS6dfXzyR2EiM7d108mwFc/QxwFHZoAH3u8kgBXn7ySoG0mrgV2XhJxjl0fi2TefRSi79oO/luv7QhHXNvRTEo9nVlylOgNnPzzV9vg33rZUN8amuH6p19yzdtdRPZfmvT/cCHX37ki7e9cWvebSFyuEbyS/IoW73axY0PyG64MVQP6O45Bl59OPsYL58tPG5IKbInIUkwYzzAPA9FKQaaMtiKMF+/fceCVzfnfuLIZ4+OfuES77bz4FD4kgb7WXCnNPz82cjno/uwxIMp7jk4Z+SgKV6NHNHjve7BFKE7W/JNGIZKfB1arUSD6kdEqg7rm6i0GksocI4IqhoNoJecP3TmvWrkyx5jgkFEg6rnHj3gsgu2PozDGWkQ9mu5CyxtXhmOI+jA6UGccSEtTeEVhiK8t4o0sQFRTKXNVnod2T9Rjw9KUaBMWBONlmQsGfaxbYYi8ssKwBdGtvlwhKeAy0xIuJMsr0wFTDyANSrJe8UzAjPacs4zH5XJkVwUA0qKk+1BK51NrhBOZ5Xt9SnbMpVFQIO2HdzjHJGMOLIqCSXFaR9TeGq4g7QeY7MqYZUy/kQWEomCryy7BbhiuINe6sDyslV2kqunDTUMI50hmIr4cltilTgGB4OsnmURplUvJBHl7fao+KcqJYFLmVRElt0e4CQAEX18kSI7FpuaSKW+MtG/8bIT2u2C6PlXpsU3kCECBoUBub0ODJCrKOGSi1Q+Q5jdqzItLZYhrEKpzlfoWFEijbxoaBNGhuFSnuM7bYYaEeb3ab8pid0xuaaugGBr9D6GWxXqTc7BIAAAAAElFTkSuQmCC",
              mining_type: MiningType.all.sample
              },
              ]
      coins.each do |coin|
      Coin.find_or_create_by!(coin)
    end
  end
end

desc "Cadastra os tipos de mineração"
task add_mining_types: :environment do
    show_spinner ("Cadastrando tipo de mineração...") do
    mining_types = [
      {description: "Proof of Work", acronym: "PoW"},
      {description: "Proof of Stake", acronym: "PoS"},
      {description: "Proof of Capacity", acronym: "PoC"},
    ]

    mining_types.each do |mining_type|
      MiningType.find_or_create_by!(mining_type)
    end
  end  
end

  private
  
  def show_spinner(msg_start, msg_end = "Concluído")
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}", format:  :pulse_2)
    spinner.auto_spin
    yield
    spinner.success("(#{msg_end})")
  end
end

 