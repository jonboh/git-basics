import 'asciinema-player/dist/bundle/asciinema-player.css'
import * as AsciinemaPlayer from 'asciinema-player';

AsciinemaPlayer.create(
'/git-basics/assets/git_log_1.cast',
document.getElementById('cast'),
{
  speed: 1.5,
  rows: 30,
  cols: 120,
  terminalFontSize: '24px',
  fit: false,
  controls: true,
},
)

