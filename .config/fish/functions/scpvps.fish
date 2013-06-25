function scpvps
  scp -i ~/.ssh/jack.pem ubuntu@mneorr.com:$argv[1] $argv[2]
end
