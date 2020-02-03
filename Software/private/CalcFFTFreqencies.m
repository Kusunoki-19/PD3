function fftFreqencies = CalcFFTFreqencies(p)
    deltaF = p.Fs / p.sampleLen;
    fftFreqencies = p.cutFreqL:deltaF:p.cutFreqH;
end