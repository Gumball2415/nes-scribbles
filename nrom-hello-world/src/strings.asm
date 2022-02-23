.include "defines.inc"
.include "global.inc"

.segment "BANK1"
; end of string is important!!!
; else, textprinter loops forever
; strings should be multiples of 28 characters (excluding line feed)!
;        ____________________________<-- up till here!!
string_test:
  .byte "sphinx of dark black quartz,"
  .byte "judge my vows...", char_LF, char_LF
  .byte "the quick brown fox did jump"
  .byte "over the lazy dog...", char_LF
  .byte char_LF, char_LF, char_LF, char_LF, char_LF, char_LF, char_LF, char_LF, char_LF, char_LF, char_LF, char_LF, char_LF, char_LF
  .byte "squeak <:3 )~", char_LF
  .byte "line feed test...", char_LF
  .byte "curveball :P", char_EOS
copyright_info:
  .byte "v.0.0.1", char_LF
  .byte "(C) SATELLITE & STARDUST ", char_SNS_LOGO, char_EOS
credits:
  .byte "Initial Template:", char_LF
  .byte "  yoeynsf", char_LF, char_LF
  .byte "Programming:", char_LF
  .byte "  Persune", char_LF, char_LF
  .byte "Programming help:", char_LF
  .byte "  yoeynsf, Kasumi, studsX,  "
  .byte "Fiskbit, Pino, zeta0134,    "
  .byte "jroweboy, & many, many more "
  .byte "others...:P", char_LF, char_LF
  .byte "Lots of thanks for you who  "
  .byte "helped me through each tiny "
  .byte "step in this, I am eternally"
  .byte "grateful!!"
  .byte char_EOS
eternal_gratitude:
  .byte "Jekuthiel, yoeynsf, Fiskbit,"
  .byte "lidnariq, Kasumi, Pinobatch,"
  .byte "studsX, Lockster, plgDavid, "
  .byte "Grievre, Iyatemu, BlueMario,"
  .byte "jroweboy, zeta0134, and also"
  .byte "the entire NESDev community."
  .byte char_LF, char_LF
  .byte "I am very grateful for all  "
  .byte "your help. I hope to return "
  .byte "the favor one day, when I am"
  .byte "much more able than I am now"
  .byte char_EOS
testline:
  .byte "Hello, NROM!"
  .byte char_EOS
lorem_ipsum:
  .byte "But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasure, but because those who do not know how to pursue pleasure rationally encounter consequences that are extremely painful. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. To take a trivial example, which of us ever undertakes laborious physical exercise, except to obtain some advantage from it? But who has any right to find fault with a man who chooses to enjoy a pleasure that has no annoying consequences, or one who avoids a pain that produces no resultant pleasure? On the other hand, we denounce with righteous indignation and dislike men who are so beguiled and demoralized by the charms of pleasure of the moment, so blinded by desire, that they cannot foresee.", char_EOS
