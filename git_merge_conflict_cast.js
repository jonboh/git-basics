import 'asciinema-player/dist/bundle/asciinema-player.css'
import * as AsciinemaPlayer from 'asciinema-player';

AsciinemaPlayer.create(
'/git-basics/assets/git_merge_conflict_2.cast',
document.getElementById('git_merge_conflict'),
{
  speed: 1.5,
  rows: 26,
  cols: 120,
  terminalFontSize: '24px',
  fit: false,
  controls: true,
},
)

