function showMask(ws,mask)

Screen('DrawTexture',ws.ptr,mask);
Screen('Flip',ws.ptr);  
