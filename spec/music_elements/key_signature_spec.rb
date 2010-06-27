describe 'Key signatures' do

  it "should return a key signature as a music element" do
    Stretto::Pattern.new("KDmaj").first.should be_an_instance_of(Stretto::MusicElements::KeySignature)
  end

  context "when interacting with elements in a composition" do

    it "should not have a default key signature (even Cmaj is default, it should not build an element)" do
      notes = Stretto::Pattern.new("C D E F G A B")
      notes.each { |note| note.key_signature.should be_nil }
    end

    it "should mark all subsequent notes as having present the key signature" do
      key_signature, *notes = Stretto::Pattern.new("KDmaj C D E F G A B")
      notes.each { |note| note.key_signature.should be == key_signature}
    end

    # Following test based on minor and major scales, and their equivalences.
    # See http://musicmattersblog.com/wp-files/KeySignatureChart.pdf
    context "when altering notes expressed with a music string" do

      context "when using the major scale" do
        it "should not alter notes if the scale is Cmaj" do
          notes = Stretto::Pattern.new("KCmaj C D E F G A B")[1..-1]
          equivalent_notes = Stretto::Pattern.new("C D E F G A B")
          notes.map(&:value).should be == [60, 62, 64, 65, 67, 69, 71]
          notes.should be == equivalent_notes
        end

        it "should raise notes half tone for F when the key signature is Gmaj" do
          notes = Stretto::Pattern.new("KGmaj C D E F G A B")[1..-1]
          equivalent_notes = Stretto::Pattern.new("C D E F# G A B")
          notes.map(&:value).should be == [60, 62, 64, 66, 67, 69, 71]
          notes.should be == equivalent_notes
        end

        it "should raise notes half tone for F, C when the key signature is Dmaj" do
          notes = Stretto::Pattern.new("KDmaj C D E F G A B")[1..-1]
          equivalent_notes = Stretto::Pattern.new("C# D E F# G A B")
          notes.map(&:value).should be == [61, 62, 64, 66, 67, 69, 71]
          notes.should be == equivalent_notes
        end

        it "should raise notes half tone for F, C, G when the key signature is Amaj" do
          notes = Stretto::Pattern.new("KAmaj C D E F G A B")[1..-1]
          equivalent_notes = Stretto::Pattern.new("C# D E F# G# A B")
          notes.map(&:value).should be == [61, 62, 64, 66, 68, 69, 71]
          notes.should be == equivalent_notes
        end

        it "should raise notes half tone for F, C, G, D when the key signature is Emaj" do
          notes = Stretto::Pattern.new("KEmaj C D E F G A B")[1..-1]
          equivalent_notes = Stretto::Pattern.new("C# D# E F# G# A B")
          notes.map(&:value).should be == [61, 63, 64, 66, 68, 69, 71]
          notes.should be == equivalent_notes
        end

        it "should raise notes half tone for F, C, G, D, A when the key signature is Bmaj" do
          notes = Stretto::Pattern.new("KBmaj C D E F G A B")[1..-1]
          equivalent_notes = Stretto::Pattern.new("C# D# E F# G# A# B")
          notes.map(&:value).should be == [61, 63, 64, 66, 68, 70, 71]
          notes.should be == equivalent_notes
        end

        it "should raise notes half tone for F, C, G, D, A, E when the key signature is F#maj" do
          notes = Stretto::Pattern.new("KF#maj C D E F G A B")[1..-1]
          equivalent_notes = Stretto::Pattern.new("C# D# E# F# G# A# B")
          notes.map(&:value).should be == [61, 63, 65, 66, 68, 70, 71]
          notes.should be == equivalent_notes
        end

        it "should raise notes half tone for F, C, G, D, A, E, B when the key signature is C#maj" do
          notes = Stretto::Pattern.new("KC#maj C D E F G A B")[1..-1]
          equivalent_notes = Stretto::Pattern.new("C# D# E# F# G# A# B#")
          notes.map(&:value).should be == [61, 63, 65, 66, 68, 70, 72]
          notes.should be == equivalent_notes
        end
      end

      context "when using the minor scale" do
        it "should not alter notes if the scale is Amin" do
          notes = Stretto::Pattern.new("KAmin C D E F G A B")[1..-1]
          equivalent_notes = Stretto::Pattern.new("C D E F G A B")
          notes.map(&:value).should be == [60, 62, 64, 65, 67, 69, 71]
          notes.should be == equivalent_notes
        end

        it "should raise notes half tone for B when the key signature is Dmin" do
          notes = Stretto::Pattern.new("KDmin C D E F G A B")[1..-1]
          equivalent_notes = Stretto::Pattern.new("C D E F G A Bb")
          notes.map(&:value).should be == [60, 62, 64, 65, 67, 69, 70]
          notes.should be == equivalent_notes
        end

        it "should raise notes half tone for B, E when the key signature is Gmin" do
          notes = Stretto::Pattern.new("KGmin C D E F G A B")[1..-1]
          equivalent_notes = Stretto::Pattern.new("C D Eb F G A Bb")
          notes.map(&:value).should be == [60, 62, 63, 65, 67, 69, 70]
          notes.should be == equivalent_notes
        end

        it "should raise notes half tone for B, E, A when the key signature is Cmin" do
          notes = Stretto::Pattern.new("KCmin C D E F G A B")[1..-1]
          equivalent_notes = Stretto::Pattern.new("C D Eb F G Ab Bb")
          notes.map(&:value).should be == [60, 62, 63, 65, 67, 68, 70]
          notes.should be == equivalent_notes
        end

        it "should raise notes half tone for B, E, A, D when the key signature is Fmin" do
          notes = Stretto::Pattern.new("KFmin C D E F G A B")[1..-1]
          equivalent_notes = Stretto::Pattern.new("C Db Eb F G Ab Bb")
          notes.map(&:value).should be == [60, 61, 63, 65, 67, 68, 70]
          notes.should be == equivalent_notes
        end

        it "should raise notes half tone for B, E, A, D, G when the key signature is Bbmin" do
          notes = Stretto::Pattern.new("KBbmin C D E F G A B")[1..-1]
          equivalent_notes = Stretto::Pattern.new("C Db Eb F Gb Ab Bb")
          notes.map(&:value).should be == [60, 61, 63, 65, 66, 68, 70]
          notes.should be == equivalent_notes
        end

        it "should raise notes half tone for B, E, A, D, G, C when the key signature is Ebmin" do
          notes = Stretto::Pattern.new("KEbmin C D E F G A B")[1..-1]
          equivalent_notes = Stretto::Pattern.new("Cb Db Eb F Gb Ab Bb")
          notes.map(&:value).should be == [59, 61, 63, 65, 66, 68, 70]
          notes.should be == equivalent_notes
        end

        it "should raise notes half tone for B, E, A, D, G, C, F when the key signature is Abmin" do
          notes = Stretto::Pattern.new("KAbmin C D E F G A B")[1..-1]
          equivalent_notes = Stretto::Pattern.new("Cb Db Eb Fb Gb Ab Bb")
          notes.map(&:value).should be == [59, 61, 63, 64, 66, 68, 70]
          notes.should be == equivalent_notes
        end
      end

      # For reference, see key signature circle in http://en.wikipedia.org/wiki/Key_signature
      context "when using equivalences in the major and minor scales" do
        context "accepting equivalences in the major scale" do
          it "should make B# equivalent to Cmaj" do
            Stretto::Pattern.new("KB#maj C D E F G A B")[1..-1].should be == Stretto::Pattern.new("KCmaj  C D E F G A B")[1..-1]
          end

          it "should make Fbmaj and E equivalent" do
            Stretto::Pattern.new("KFbmaj C D E F G A B")[1..-1].should be == Stretto::Pattern.new("KEmaj  C D E F G A B")[1..-1]
          end

          it "should make Cbmaj and Bmaj equivalent" do
            Stretto::Pattern.new("KCbmaj C D E F G A B")[1..-1].should be == Stretto::Pattern.new("KBmaj  C D E F G A B")[1..-1]
          end

          it "should make Gbmaj and F#maj equivalent" do
            Stretto::Pattern.new("KGbmaj C D E F G A B")[1..-1].should be == Stretto::Pattern.new("KF#maj C D E F G A B")[1..-1]
          end

          it "should make Dbmaj and C#maj equivalent" do
            Stretto::Pattern.new("KDbmaj C D E F G A B")[1..-1].should be == Stretto::Pattern.new("KC#maj C D E F G A B")[1..-1]
          end

          begin
            it "should ask what to do here"
            # While being enharmonic equivalents (that is, they sound the same due to note transposition),
            # they don't have the same values. We'll leave their enharmonic equivalent in the opposite scale
            # by now. We should agree if allow this, and/or add whole tones (double sharps or flats) to notes

            it "should make G#maj and Abmaj equivalent to Fmin" do
              Stretto::Pattern.new("KG#maj C D E F G A B")[1..-1].should be == Stretto::Pattern.new("KFmin  C D E F G A B")[1..-1]
              Stretto::Pattern.new("KAbmaj C D E F G A B")[1..-1].should be == Stretto::Pattern.new("KFmin  C D E F G A B")[1..-1]
            end

            it "should make D#maj and Ebmaj equivalent to Cmin" do
              Stretto::Pattern.new("KD#maj C D E F G A B")[1..-1].should be == Stretto::Pattern.new("KCmin  C D E F G A B")[1..-1]
              Stretto::Pattern.new("KEbmaj C D E F G A B")[1..-1].should be == Stretto::Pattern.new("KCmin  C D E F G A B")[1..-1]
            end

            it "should make A#maj and Bbmaj equivalent to Gmin" do
              Stretto::Pattern.new("KA#maj C D E F G A B")[1..-1].should be == Stretto::Pattern.new("KGmin  C D E F G A B")[1..-1]
              Stretto::Pattern.new("KBbmaj C D E F G A B")[1..-1].should be == Stretto::Pattern.new("KGmin  C D E F G A B")[1..-1]
            end

            it "should make E#maj and Fmaj equivalent to Dmin" do
              Stretto::Pattern.new("KE#maj C D E F G A B")[1..-1].should be == Stretto::Pattern.new("KDmin  C D E F G A B")[1..-1]
              Stretto::Pattern.new("KFmaj  C D E F G A B")[1..-1].should be == Stretto::Pattern.new("KDmin  C D E F G A B")[1..-1]
            end
          end
        end

        context "accepting equivalences in the minor scale" do
          it "should make B#min equivalent to Cmin" do
            Stretto::Pattern.new("KB#min C D E F G A B")[1..-1].should be == Stretto::Pattern.new("KCmin  C D E F G A B")[1..-1]
          end

          it "should make E#min equivalent to Fmin" do
            Stretto::Pattern.new("KE#min C D E F G A B")[1..-1].should be == Stretto::Pattern.new("KFmin  C D E F G A B")[1..-1]
          end

          it "should make A#min equivalent to Bbmin" do
            Stretto::Pattern.new("KA#min C D E F G A B")[1..-1].should be == Stretto::Pattern.new("KBbmin C D E F G A B")[1..-1]
          end

          it "should make D#min equivalent to Ebmin" do
            Stretto::Pattern.new("KD#min C D E F G A B")[1..-1].should be == Stretto::Pattern.new("KEbmin C D E F G A B")[1..-1]
          end

          it "should make G#min equivalent to Abmin" do
            Stretto::Pattern.new("KG#min C D E F G A B")[1..-1].should be == Stretto::Pattern.new("KAbmin C D E F G A B")[1..-1]
          end

          begin
            it "should decide what to do here"
            # See above

            it "should make Dbmin and C#min equivalent to Emaj" do
              Stretto::Pattern.new("KDbmin C D E F G A B")[1..-1].should be == Stretto::Pattern.new("KEmaj  C D E F G A B")[1..-1]
              Stretto::Pattern.new("KC#min C D E F G A B")[1..-1].should be == Stretto::Pattern.new("KEmaj  C D E F G A B")[1..-1]
            end

            it "should make Gbmin and F#min equivalent to Amaj" do
              Stretto::Pattern.new("KGbmin C D E F G A B")[1..-1].should be == Stretto::Pattern.new("KAmaj  C D E F G A B")[1..-1]
              Stretto::Pattern.new("KF#min C D E F G A B")[1..-1].should be == Stretto::Pattern.new("KAmaj  C D E F G A B")[1..-1]
            end

            it "should make Cbmin and Bmin equivalent to Dmaj" do
              Stretto::Pattern.new("KCbmin C D E F G A B")[1..-1].should be == Stretto::Pattern.new("KDmaj  C D E F G A B")[1..-1]
              Stretto::Pattern.new("KBmin  C D E F G A B")[1..-1].should be == Stretto::Pattern.new("KDmaj  C D E F G A B")[1..-1]
            end

            it "should make Fbmin and Emin equivalent to Gmaj" do
              Stretto::Pattern.new("KFbmin C D E F G A B")[1..-1].should be == Stretto::Pattern.new("KGmaj  C D E F G A B")[1..-1]
              Stretto::Pattern.new("KEmin  C D E F G A B")[1..-1].should be == Stretto::Pattern.new("KGmaj  C D E F G A B")[1..-1]
            end
          end
        end
      end
      
    end

    context "when altering a note with an already specified accidental" do
      it "should not alter the note when a sharp is placed in a note already raised by a key signature"
      it "should not lower the note when a flat is placed in a note already lowered by a key signature"
      it "should only raise half tone when a double sharp is placed in a note raised by a key signature"
      it "should only lower half tone when a double flat is placed in a note lowered by a key signature"
      it "should leave the note in its natural state when there is a natural accidental"


      it "should ask what to do when a flat is placed on a lowered note by a key signature"
      it "should ask what to do when a sharp is placed on a raised note by a key signature"
    end

  end

  context "when using it on a multi voice composition" do
    it "should affect only the track it is applied to"
    it "should reset the key signature per track independently"
  end

end