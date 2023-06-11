<TeXmacs|2.1>

<style|article>

<\body>
  <doc-data|<doc-title|Quantum algorithms for
  optimization>|<doc-author|<author-data|<author-name|Sumeet
  Shirgure>|<\author-affiliation>
    USC, Spring 2022
  </author-affiliation>>>>

  <abstract-data|<abstract|This article documents and discusses existing
  methods and some recent developments in the field of quantum computing in
  solving combinatorial and optimization problems.>>

  <section|Introduction>

  In recent years there has been considerable progress in quantum computing
  theory and technology. An interesting sub-field of applications of quantum
  algorithms is in solving optimization problems faster than classically
  possible. However, since the information processed by such algorithms is
  quantum in nature, we must also be aware of their utility and limitations.

  This paper attempts to discuss these topics at a high level without going
  too deep into the technical details, and is supposed to be accessible to
  anyone without a background in quantum computing.

  Section <reference|section_qcintro> gives a bare minimum introduction to
  quantum mechanics and quantum computation, and only requires a working
  knowledge of complex valued linear algebra. <cite|axler> is a great
  reference. Section <reference|section_qctools> introduces some standard
  tools in quantum computing. And the later sections each discuss a relevent
  topic in adequate detail. A few topics that serve to tie some loose ends
  are deferred to the appendices. A reader uninterested in quantum computing
  might still find the contents of section <reference|section_sdp> of
  considerable interest, because the majority of that discussion is in the
  classical domain.

  <section|A crash course in quantum computing ><label|section_qcintro>

  A short introduction to quantum computing is <cite|qcintro>. Here we review
  some basic concepts at the bare minimum, which are discussed in any text,
  such as <cite|mike_and_ike>, on the subject. We will start by reviewing
  three basic postulates of quantum mechanics \U (a) state description, (b)
  state collapse and measurement statistics, and (c) evolution.

  <subsection|Postulates>

  Quantum information is processed and stored in quantum computers in the
  form of quantum bits or qubits. The state of any quantum mechanical system
  is postulated to be a vector <math|\<psi\>> belonging to a complex Hilbert
  space <math|\<cal-H\>> that is normalized w.r.t that inner product
  <math|<around|\<langle\>|.,.|\<rangle\>>>. Qubits are quantum systems for
  which this Hilbert space is the 2D complex vector space
  <math|\<bbb-C\><rsup|2>>.

  As a mathematical abstraction, every qubit state is given by a normalized
  2D complex vector <math|<matrix|<tformat|<table|<row|<cell|\<alpha\>>>|<row|<cell|\<beta\>>>>>>=\<alpha\><matrix|<tformat|<table|<row|<cell|1>>|<row|<cell|0>>>>>+\<beta\><matrix|<tformat|<table|<row|<cell|0>>|<row|<cell|1>>>>>=\<alpha\><around*|\||0|\<rangle\>>+\<beta\><around*|\||1|\<rangle\>>,<around*|\||\<alpha\>|\|><rsup|2>+<around*|\||\<beta\>|\|><rsup|2>=1>.
  <math|<around*|\||0|\<rangle\>><infix-and><around*|\||1|\<rangle\>>> (see
  section <reference|bra_ket> for notation) being a basis of
  <math|\<bbb-C\><rsup|2>> are also called the
  <with|font-shape|italic|computational basis> states. When parametrizing the
  qubit state by <math|e<rsup|i\<gamma\>><around*|(|cos<around*|(|\<theta\>|)><around|\||0|\<rangle\>>+e<rsup|i\<varphi\>>sin<around*|(|\<theta\>|)><around*|\||1|\<rangle\>>|)>>,
  we can ignore <math|\<gamma\>>, called the global phase, as we will see it
  has no <with|font-shape|italic|observable effects>.

  Physical quantities of interest like position, momenta, energy, spin are
  are represented by <with|font-shape|italic|observables>, which are linear
  operators acting on <math|\<cal-H\>>. An important example is the energy
  operator <math|<wide|H|^>> - the Hamiltonian. A fundamental idea in quantum
  mechanics is that the eigenvalues of any observable correspond to
  physically observed quantities. Since these should be real even for complex
  vector states, the observables are always Hermitian, i.e they must have
  real eigenvalues : <math|<wide|H|^><rsup|\<dagger\>>=<wide|H|^>>. This
  possibility of a discrete nature of energy eigenvalues is at the heart of
  quantum mechanics.

  The eigenvectors corresponding to an operator are called its
  <with|font-shape|italic|eigenstates>. If a quantum system
  <math|<around*|\||\<psi\>|\<rangle\>>> is in a linear combination of
  eigenstates <math|<big|sum><rsub|j>\<alpha\><rsub|j><around*|\||\<psi\><rsub|j>|\<rangle\>>>,
  it's said to be in a <with|font-shape|italic|quantum superposition> of
  those states. When the associated physical quantity observed, such a state
  is postulated to <with|font-shape|italic|collapse> to the respective
  eigenstate <math|<around*|\||\<psi\><rsub|j>|\<rangle\>>>. The probability
  of observing <math|m> is given by the Born rule :
  <math|<around*|\||\<alpha\><rsub|m>|\|><rsup|2>/<big|sum><rsub|j><around*|\||\<alpha\><rsub|j>|\|><rsup|2>>.
  That is, the probabilities are proportional to the magnitudes of the
  corresponding <with|font-shape|italic|amplitudes> <math|\<alpha\><rsub|j>>.
  This is why the global phases are unobservable. The state
  <math|<around*|\||\<psi\><rsub|j>|\<rangle\>>> after the collapse is again
  normalized.

  E.g the qubit state <math|\<alpha\><rsub|0><around*|\||0|\<rangle\>>+\<alpha\><rsub|1><around*|\||1|\<rangle\>>>
  when measured in the computational basis is put in the state
  <math|<around*|\||j|\<rangle\>>> after measurement with probability
  <math|<around*|\||\<alpha\><rsub|j>|\|><rsup|2>>, and we observe the event
  labeled <math|j> in the form of some physical phenomenon.

  Lastly, the continuous time evolution of a closed quantum system is
  described by the <math|Schr<math|<wide|o|\<ddot\>>>dinger> equation <math|i
  \<hbar\><frac|d|d t><around*|\||\<psi\><around*|(|t|)>|\<rangle\>>=<wide|H|^><around*|\||\<psi\><around*|(|t|)>|\<rangle\>>>,
  <math|<wide|H|^>> being the energy operator.

  The is a linear differential equation and is solved by
  <math|<around*|\||\<psi\><around*|(|t|)>|\<rangle\>>=e<rsup|-i
  <wide|H|^>t/\<hbar\>><around*|\||\<psi\><around*|(|0|)>|\<rangle\>>>, where
  the exponentiation is the usual function of the operator <math|<wide|H|^>>.
  The Hamiltonian doesn't change with time because closed systems have
  conserved energy.

  <math|U<around*|(|t|)>=e<rsup|-i <wide|H|^>t/\<hbar\>>> is a unitary
  operator, as it should be to keep <math|\<psi\>> normalized \U

  <\padded-center>
    <math|U<around*|(|t|)><rsup|\<dagger\>>=<big|sum><rsub|k\<geqslant\>0><frac|1|k!><around*|(|<around*|(|<frac|-i
    <wide|H|^>t|\<hbar\>>|)><rsup|k>|)><rsup|\<dagger\>>=<big|sum><rsub|k\<geqslant\>0><frac|1|k!><around*|(|<frac|i
    <wide|H|^>t|\<hbar\>>|)><rsup|k>=e<rsup|i
    <wide|H|^>t/\<hbar\>>=U<around*|(|t|)><rsup|-1>>
  </padded-center>

  The exponential of a skew-Hermitian operator is always unitary. As we will
  see, quantum logic gates must also be unitary. This is a key necessary
  condition to prevent loss of information, which is essential when we
  consider thermally isolated closed systems \U a consequence of what is
  known as Landauer's principle <cite|heat>.

  <subsection|The quantum gate model>

  The standard model of quantum computation is described in terms of a series
  of <with|font-shape|italic|quantum logic gates> applied on a set of qubits.
  Each gate acts on a small subset of qubits. Let's start by understanding
  how to express composite states with multiple qubits.

  <subsubsection|Composite states>

  The main idea is to take products of the corresponding Hilbert spaces. The
  composite state is then the tensor product (also called the Kronecker
  product) of the two states.

  E.g if two qubits are in states <math|<matrix|<tformat|<table|<row|<cell|\<alpha\>>>|<row|<cell|\<beta\>>>>>>=\<alpha\><around*|\||0|\<rangle\>>+\<beta\><around*|\||1|\<rangle\>>>
  and <math|<matrix|<tformat|<table|<row|<cell|\<mu\>>>|<row|<cell|\<nu\>>>>>>=\<mu\><around*|\||0|\<rangle\>>+\<nu\><around*|\||1|\<rangle\>>>,
  the composite system is in the state <math|<matrix|<tformat|<table|<row|<cell|\<alpha\>>>|<row|<cell|\<beta\>>>>>>\<otimes\><matrix|<tformat|<table|<row|<cell|\<mu\>>>|<row|<cell|\<nu\>>>>>>=<matrix|<tformat|<table|<row|<cell|\<alpha\>\<mu\>>>|<row|<cell|\<alpha\>\<nu\>>>|<row|<cell|\<beta\>\<mu\>>>|<row|<cell|\<beta\>\<nu\>>>>>>>

  \ <math|=<around*|(|\<alpha\><around*|\||0|\<rangle\>>+\<beta\><around*|\||1|\<rangle\>>|)>\<otimes\><around*|(|\<mu\><around*|\||0|\<rangle\>>+\<nu\><around*|\||1|\<rangle\>>|)>=\<alpha\>\<mu\><around*|\||0|\<rangle\>>\<otimes\><around*|\||0|\<rangle\>>+\<alpha\>\<nu\><around*|\||0|\<rangle\>>\<otimes\><around*|\||1|\<rangle\>>+\<beta\>\<mu\><around*|\||1|\<rangle\>>\<otimes\><around*|\||0|\<rangle\>>+\<beta\>\<nu\><around*|\||1|\<rangle\>>\<otimes\><around*|\||1|\<rangle\>>>

  <math|<around*|\||j|\<rangle\>>\<otimes\><around*|\||k|\<rangle\>>> is
  abbreviated as <math|<around*|\||j k|\<rangle\>>>. Sequences of qubits in
  computational basis can be represented as bitstrings inside a ket
  <math|<around*|\|||\<rangle\>>>. The above state is written in the
  <math|<around*|\||00|\<rangle\>>,<around*|\||01|\<rangle\>>,<around*|\||10|\<rangle\>>,<around*|\||11|\<rangle\>>>
  basis of the product Hilbert space <math|\<bbb-C\><rsup|2<rsup|2>>>. Hence,
  <math|n> qubits have <math|\<bbb-C\><rsup|2<rsup|n>>> dimensional states.
  This apparent complexity is not entirely observable, however. Still quantum
  computers can process information by moving around in such large spaces.

  Yet another crucial phenomonon is that of <with|font-shape|italic|entangled
  states>. There exist states like <math|<frac|<around*|\||00|\<rangle\>>+<around*|\||11|\<rangle\>>|<sqrt|2>>>
  that can't be expressed as the tensor product of two states. Such entangled
  states are physically realizable, and imply that measuring one qubit will
  immediately tell us about the state of the other when it is measured. Even
  if this state itself is not a product of two single-qubit states, it does
  lie in the product Hilbert space of the two qubits, which is what the
  postulate requires.

  Measuring just the first qubit of <math|<big|sum><rsub|p q>\<alpha\><rsub|p
  q><around*|\||p q|\<rangle\>>> results in an observation corresponding to
  the <math|<around*|\||0|\<rangle\>>> state, the final state is
  <math|<frac|<big|sum><rsub|q>\<alpha\><rsub|0 q><around*|\||0
  q|\<rangle\>>|<big|sum><rsub|q><around*|\||\<alpha\><rsub|0>q|\|><rsup|2>>>.
  The probability of this happening is <math|<big|sum><rsub|q><around*|\||\<alpha\><rsub|0q>|\|><rsup|2>>.

  <subsubsection|Qubit gates><label|qubit_gates>

  State evolution must be unitary to keep <math|\<psi\>> normalized. The
  states of qubits are manipulated using quantum gates that are unitary
  operators acting on corresponding Hilbert spaces. E.g, the NOT gate
  <math|X=<matrix|<tformat|<table|<row|<cell|0>|<cell|1>>|<row|<cell|1>|<cell|0>>>>>>
  maps <math|\<alpha\><around*|\||0|\<rangle\>>+\<beta\><around*|\||1|\<rangle\>>>
  to <math|\<beta\><around*|\||0|\<rangle\>>+\<alpha\><around*|\||1|\<rangle\>>>,
  effectively acting as a negation. Any <math|2\<times\>2> unitary matrix
  <math|U> acts on a qubit in state <math|<around*|\||\<psi\>|\<rangle\>>> to
  give <math|U<around*|\||\<psi\>|\<rangle\>>>.

  Multiple single-qubit gates <math|U<rsub|i>,U<rsub|j>> acting on
  <math|<around*|\||\<varphi\>|\<rangle\>>,<around*|\||\<psi\>|\<rangle\>>>
  is equivalent to <math|U<rsub|i>\<otimes\>U<rsub|j>> acting on
  <math|<around*|\||\<varphi\>|\<rangle\>>\<otimes\><around*|\||\<psi\>|\<rangle\>>>
  : <math|U<rsub|i>\<otimes\>U<rsub|j><around*|(|<around*|\||\<varphi\>|\<rangle\>>\<otimes\><around*|\||\<psi\>|\<rangle\>>|)>=<around*|(|U<rsub|i><around*|\||\<varphi\>|\<rangle\>>|)>\<otimes\><around*|(|U<rsub|j><around*|\||\<psi\>|\<rangle\>>|)>>.
  More generally, a single unitary operation <math|U> can act on multiple
  qubits. E.g, the controlled-NOT, or <math|CNOT=<matrix|<tformat|<table|<row|<cell|1>|<cell|0>|<cell|0>|<cell|0>>|<row|<cell|0>|<cell|1>|<cell|0>|<cell|0>>|<row|<cell|0>|<cell|0>|<cell|0>|<cell|1>>|<row|<cell|0>|<cell|0>|<cell|1>|<cell|0>>>>>>
  mapping <math|<around*|\||p|\<rangle\>>\<otimes\><around*|\||q|\<rangle\>>\<rightarrow\><around*|\||p|\<rangle\>>\<otimes\><around*|\||q\<oplus\>p|\<rangle\>>>
  where <math|\<oplus\>> is bitwise exclusive or. Note how it's convenient to
  just talk of the action of quantum gates on basis states, because linearity
  uniquely extends the definition to superposition states.

  The set of all single qubit unitaries along with CNOT is a universal gate
  set. And even if the number of unitary transformations is uncountably
  infinite, there always exist modest-sized finite gate sequences that
  approximate any desired operation up to an acceptable error in the operator
  norm \U this result is given by the Solovay-Kitaev theorem
  <cite|solovay_kitaev_algorithm>.

  Quantum gates are a generalization of classical gates. However, classical
  gates like AND and OR destroy information irreversibly. Their quantum
  analogs can be implemented using reversible gates like the Toffoli gate
  <math|C C X<around*|\||x|\<rangle\>>*\<otimes\><around*|\||y|\<rangle\>>*\<otimes\><around*|\||z|\<rangle\>>*\<rightarrow\><around*|\||x|\<rangle\>>*\<otimes\><around*|\||y|\<rangle\>>*\<otimes\><around*|\||z\<oplus\><around*|(|x\<wedge\>y|)>|\<rangle\>>>.
  Bennet <cite|revcomp> showed that any classical computation can be made
  reversible like this, with an acceptable overhead in the number of qubits
  and gates.

  Some standard qubit gates are the Pauli gates <math|X>,
  <math|Y=<matrix|<tformat|<table|<row|<cell|0>|<cell|-i>>|<row|<cell|i>|<cell|0>>>>>,Z=<matrix|<tformat|<table|<row|<cell|1>|<cell|0>>|<row|<cell|0>|<cell|-1>>>>>>,
  the Hadamard gate <math|H=<frac|1|<sqrt|2>><matrix|<tformat|<table|<row|<cell|1>|<cell|1>>|<row|<cell|1>|<cell|-1>>>>>>,
  phase shift gates <math|P<around*|(|\<varphi\>|)>=<matrix|<tformat|<table|<row|<cell|1>|<cell|0>>|<row|<cell|0>|<cell|e<rsup|2
  \<pi\>i\<varphi\>>>>>>>>. A common operation is to put a set of <math|n>
  qubits each in the uniform superposition
  <math|<around*|(|<around*|\||0|\<rangle\>>+<around*|\||1|\<rangle\>>|)>/<sqrt|2>=H<around*|\||0|\<rangle\>>>.
  The composite state <math|<around*|(|<frac|<around*|\||0|\<rangle\>>+<around*|\||1|\<rangle\>>|<sqrt|2>>|)><rsup|\<otimes\>n>=2<rsup|-n/2><big|sum><rsub|x\<in\>\<bbb-Z\><rsub|2><rsup|n>><around*|\||x|\<rangle\>>>
  is a uniform sum of all bit strings. This can, for example, represent the
  search space of all <math|2<rsup|n>> subsets in a search problem.

  \ 

  <\big-figure>
    <with|gr-mode|<tuple|edit|text-at>|gr-frame|<tuple|scale|1cm|<tuple|0.5gw|0.5gh>>|gr-geometry|<tuple|geometry|1par|0.6par>|gr-grid|<tuple|empty>|gr-grid-old|<tuple|cartesian|<point|0|0>|1>|gr-edit-grid-aspect|<tuple|<tuple|axes|none>|<tuple|1|none>|<tuple|10|none>>|gr-edit-grid|<tuple|empty>|gr-edit-grid-old|<tuple|cartesian|<point|0|0>|1>|gr-auto-crop|true|<graphics||<line|<point|0|4>|<point|3.0|4.0>>|<point|1.5|4>|<point|1.5|4>|<line|<point|1.5|3.0>|<point|1.5|4.0>>|<line|<point|1|3>|<point|2.0|3.0>|<point|2.0|2.0>|<point|1.0|2.0>|<point|1.0|3.0>>|<line|<point|0|2.4>|<point|1.0|2.4>>|<line|<point|2|2.4>|<point|3.0|2.4>>|<text-at|<math|<around*|\||x|\<rangle\>>>|<point|0.2|2.6>>|<text-at|<math|U<rsup|c><around*|\||x|\<rangle\>>>|<point|2.4|2.6>>|<text-at|<math|U>|<point|1.4|2.5>>|<text-at|<math|<around*|\||c|\<rangle\>>>|<point|0.2|4.1>>|<text-at||<point|2.7|3.7>>>><space|5em><with|gr-mode|<tuple|edit|line>|gr-frame|<tuple|scale|1cm|<tuple|0.729978gw|0.559994gh>>|gr-geometry|<tuple|geometry|1par|0.6par>|gr-grid|<tuple|empty>|gr-grid-old|<tuple|cartesian|<point|0|0>|1>|gr-edit-grid-aspect|<tuple|<tuple|axes|none>|<tuple|1|none>|<tuple|10|none>>|gr-edit-grid|<tuple|empty>|gr-edit-grid-old|<tuple|cartesian|<point|0|0>|1>|gr-text-at-valign|center|gr-auto-crop|true|gr-text-at-halign|right|<graphics||<cline|<point|-1.3|3.0>|<point|1.0|3.0>|<point|1.0|1.0>|<point|-2.0|1.0>|<point|-2.0|3.0>>|<text-at|<math|U<rsub|f>>|<point|-0.7|2.0>>|<line|<point|-3.0|2.6>|<point|-2.0|2.6>>|<text-at|<math|<around*|\||y|\<rangle\>>>|<point|-3.0|1.7>>|<line|<point|-3|1.4>|<point|-2.0|1.4>>|<text-at|<math|<around*|\||x|\<rangle\>>>|<point|1.3|2.8>>|<text-at|<math|<around*|\||y\<oplus\>f<around*|(|x|)>|\<rangle\>>>|<point|1.2|1.6>>|<line|<point|1.0|2.6>|<point|3.0|2.6>>|<line|<point|1.0|1.4>|<point|3.0|1.4>>|<text-at|<math|<around*|\||x|\<rangle\>>>|<point|-3.0|2.8>>|<line|<point|-2.5|2.4>|<point|-2.2|2.8>>|<with|text-at-valign|center|text-at-halign|right|<text-at|<math|n>|<point|-2.3|2.3>>>|<line|<point|2.3|2.8>|<point|2.0|2.4>>>>

    (a) A controlled unitary<space|5em>(b) A reversible unitary computing
    <math|f>

    \;
  <|big-figure>
    <label|ckt_diags>Circuit diagrams of common operations
  </big-figure>

  \;

  Like the CNOT gate, we may condition any unitary on the state of an
  external qubit, depicted diagramatically as in figure
  <reference|ckt_diags>(a). <math|<around*|\||c|\<rangle\>>\<otimes\><around*|\||x|\<rangle\>>\<longrightarrow\><around*|\||c|\<rangle\>>\<otimes\>U<rsup|c><around*|\||x|\<rangle\>>>;
  <math|U> is applied only when the control qubit is
  <math|<around*|\||1|\<rangle\>>>. The equivalent unitary is
  <math|<around*|(|<around*|\||0|\<rangle\>><around|\<langle\>|0|\|>\<otimes\>I+<around|\||1|\<rangle\>><around|\<langle\>|1|\|>\<otimes\>U|)>>
  (see section <reference|bra_ket>). Controlled unitaries can hence be
  extended to arbitrary circuits being conditioned on another qubit. Physical
  implementation of controlled unitaries is an issue we won't be concerned
  with.

  Any <math|n> bit circuit <math|f:\<bbb-Z\><rsub|2><rsup|n>\<rightarrow\>\<bbb-Z\><rsub|2>>
  can be implemented as a unitary operation <math|U<rsub|f>> (figure
  <reference|ckt_diags>(b)) acting on <math|n+1> qubits that acts as
  <math|U<rsub|f><around*|\||x|\<rangle\>>\<otimes\><around|\||y|\<rangle\>>\<longrightarrow\><around*|\||x|\<rangle\>>\<otimes\><around*|\||y\<oplus\>f<around*|(|x|)>|\<rangle\>>>.
  Applying <math|U<rsub|f>> to <math|<around*|\||x|\<rangle\>>\<otimes\><around*|\||0|\<rangle\>>>
  gives us <math|<around*|\||x|\<rangle\>>\<otimes\><around*|\||f<around*|(|x|)>|\<rangle\>>>.
  <math|U<rsub|f>> may require additional <math|<around*|\||0|\<rangle\>>>
  qubits as temporary memory, but we can always return that temporary memory
  to its original state by <with|font-shape|italic|uncomputing> the
  intermediate garbage.

  Consider the effect of <math|U<rsub|f>> on
  <math|2<rsup|-n/2><big|sum><rsub|x\<in\>\<bbb-Z\><rsub|2><rsup|n>><around*|\||x|\<rangle\>>\<oplus\><around*|\||0|\<rangle\>>\<longrightarrow\>><space|1em><math|2<rsup|-n/2><big|sum><rsub|x\<in\>\<bbb-Z\><rsub|2><rsup|n>><around*|\||x|\<rangle\>>\<oplus\><around*|\||f<around*|(|x|)>|\<rangle\>>>.
  The physical apparatus implementing <math|U<rsub|f>> must somehow
  simultaneously evaluate <math|f> at every point. And yet, we cannot access
  more than one function output without measuring the resulting state more
  than once. Even still, such <with|font-shape|italic|quantum parallelism> is
  useful for designing quantum algorithms.

  <subsubsection|Measurement>

  Measurement of a qubit collapses its state into a
  <math|<around*|\||0|\<rangle\>>> or a <math|<around*|\||1|\<rangle\>>>,
  which we then observe as a classical bit. Since measurement is non-unitary,
  it can be used to affect non-unitary transformations that we might need.
  E.g consider the state <math|<around*|\||\<psi\>|\<rangle\>>=<frac|<around*|\||00|\<rangle\>>+<around*|\||01|\<rangle\>>+<around*|\||10|\<rangle\>>|<sqrt|3>>>.
  We cannot prepare this just by using unitary gates on two qubits
  initialized to <math|<around*|\||0|\<rangle\>>>. We can however add an
  ancillary qubit, and use it to store the AND of the first two :

  <math|<around*|\||000|\<rangle\>>\<rightarrow\><around*|[|H<rsup|\<otimes\>2>\<otimes\>I|]>\<rightarrow\><frac|1|2><around*|(|<around*|\||00|\<rangle\>>+<around*|\||01|\<rangle\>>+<around*|\||10|\<rangle\>>+<around*|\||11|\<rangle\>>|)>\<otimes\><around*|\||0|\<rangle\>>\<rightarrow\><around*|[|C
  C X|]>\<rightarrow\><frac|<around*|\||000|\<rangle\>>+<around*|\||010|\<rangle\>>+<around*|\||100|\<rangle\>>+<around*|\||111|\<rangle\>>|2>>

  <math|> Now, we just measure the 3rd qubit, and keep repeating the
  experiment until we observe it collapse to
  <math|<around*|\||0|\<rangle\>>>; which would then imply that the first two
  qubits are in state <math|<around*|\||\<psi\>|\<rangle\>>>. The required
  observation occurs with probability 3/4, so we need <math|4/3> repetitions
  of the experiment in expectation. We can hence use partial measurement also
  as a technique to create quantum states via non-unitary transformations.

  <subsection|The bra-ket notation><label|bra_ket>

  Lastly, since Dirac's bra-ket notation is quite convenient, we'll discuss a
  bit more about it here. <math|<around*|\||x|\<rangle\>>> (pronounced
  <with|font-shape|italic|ket>) is used to denote a vector in space <math|V>.
  <math|<around|\<langle\>|x|\|>> (<with|font-shape|italic|bra>) is the
  complex conjugate transpose of <math|<around*|\||x|\<rangle\>>>, and is a
  dual vector in the dual space <math|V<rsup|>>*. The standard inner product
  of two complex vectors <math|<around|\<langle\>|x,y|\<rangle\>>=<around*|(|<around*|\||x|\<rangle\>>|)><rsup|\<dagger\>><around*|\||y|\<rangle\>>=<big|sum><rsub|i><wide|x<rsub|i>|\<bar\>>
  y<rsub|i>> is denoted as <math|<around|\<langle\>|x<around*|\|||\<nobracket\>>y|\<rangle\>>>.
  (<math|<wide|x<rsub|i>|\<bar\>>> denoting complex conjugates.) As usual,
  <math|<around|\<langle\>|x,y|\<rangle\>>=<wide|<around|\<langle\>|y,x|\<rangle\>>|\<bar\>>>.
  The <math|x> inside <math|<around*|\||x|\<rangle\>>> can be anything as per
  our convenience.

  Bra-ket notations are useful to describe operators as sums of outer
  products. E.g a unitary <math|U> mapping an orthonormal basis <math|e> to
  another <math|e<rprime|'>> as <math|U<around*|\||e<rsub|j>|\<rangle\>>\<rightarrow\>e<rsup|i\<varphi\><rsub|j>><around*|\||e<rsub|j><rprime|'>|\<rangle\>>>,
  must be of the form <math|<big|sum><rsub|j>e<rsup|i\<varphi\><rsub|j>><around*|\||e<rsub|j><rprime|'>|\<rangle\>><around|\<langle\>|e<rsub|j>|\|>>.
  Indeed <math|U<around*|\||e<rsub|k>|\<rangle\>>=<around*|(|<big|sum><rsub|j>e<rsup|i\<varphi\><rsub|j>><around*|\||e<rsub|j><rprime|'>|\<rangle\>><around|\<langle\>|e<rsub|j>|\|>|)><around*|\||e<rsub|k>|\<rangle\>>=<big|sum><rsub|j>e<rsup|i\<varphi\><rsub|j>><around*|\||e<rsub|j><rprime|'>|\<rangle\>><around|\<langle\>|e<rsub|j><around*|\|||\<nobracket\>>e<rsub|k>|\<rangle\>>=<big|sum><rsub|j>\<delta\><rsub|k
  j>e<rsup|i\<varphi\><rsub|j>><around*|\||e<rsub|j><rprime|'>|\<rangle\>>=e<rsup|i\<varphi\><rsub|k>><around*|\||e<rsub|k><rprime|'>|\<rangle\>>>,
  where <math|<around|\<langle\>|e<rsub|k><around*|\|||\<nobracket\>>e<rsub|j>|\<rangle\>>=\<delta\><rsub|k
  j>> is 1 iff <math|k=j> and is 0 otherwise.\ 

  As another example, if an observable <math|H> has eigenvalues
  <math|h<rsub|i>> and eigenstates <math|<around*|\||u<rsub|i>|\<rangle\>>>,
  the spectral theorem states <math|H=<big|sum><rsub|i>h<rsub|i><around*|\||u<rsub|i>|\<rangle\>><around|\<langle\>|u<rsub|i>|\|>>.
  Note that <math|<around*|\||u<rsub|i>|\<rangle\>><around|\<langle\>|u<rsub|i>|\|>>
  is a projection on the <math|i<rsup|th>> eigenvector of <math|H>.

  The expected eigenvalue of an observable
  <math|H=<big|sum><rsub|i>h<rsub|i><around|\||u<rsub|i>|\<rangle\>><around|\<langle\>|u<rsub|i>|\|>>
  exhibited by a state <math|<around*|\||\<psi\>|\<rangle\>>> is
  <math|<big|sum><rsub|i>h<rsub|i><around*|\||<around|\<langle\>|u<rsub|i><around*|\|||\<nobracket\>>\<psi\>|\<rangle\>>|\|><rsup|2>=<big|sum><rsub|i>h<rsub|i><around|\<langle\>||\<nobracket\>>\<psi\><around*|\||u<rsub|i>|\<rangle\>><around|\<langle\>|u<rsub|i><around*|\|||\<nobracket\>>\<psi\>|\<rangle\>>=<around|\<langle\>|\<psi\><around*|\||<around*|(|<big|sum><rsub|i>h<rsub|i><around|\||u<rsub|i>|\<rangle\>><around|\<langle\>|u<rsub|i>|\|>|)>
  |\|>\<psi\> |\<rangle\>>=<around|\<langle\>|\<psi\><around*|\||H|\|>\<psi\>|\<rangle\>>>,
  where <math|<around|\<langle\>|u<rsub|i><around*|\|||\<nobracket\>>\<psi\>|\<rangle\>>>
  are the projections of <math|\<psi\>> along the eigenstates of <math|H>,
  and the <math|l<rsub|2>>-norm-squares are probabilities by the Born rule.

  <section|Some standard quantum algorithms><label|section_qctools>

  Here we discuss some standard quantum algorithms. These are useful
  techniques for solving combinatorial problems in themselves, and can also
  be used to design more sophisticated ones. This is by no means a complete
  collection.

  <subsection|Amplitude amplification><label|section_ampl>

  Discovered by Grover <cite|Grover_1998>, and independently by Brassard et.
  al <cite|Brassard_2002> amplitude amplification referst to a broad set of
  techniques to manipulate superpositions into states having higher
  amplitudes associated with eigenstates we prefer. As an example we'll look
  at Grover's algorithm.

  Suppose we are given a unitary oracle <math|U<rsub|f>> for a boolean
  formula <math|f:\<bbb-Z\><rsub|2><rsup|n>\<rightarrow\>\<bbb-Z\><rsub|2>>
  (section <reference|qubit_gates>), and we wish to identify some n-bit
  strings <math|x> satisfying <math|f<around*|(|x|)>=1>. <math|U<rsub|f>>
  acts as <math|U<rsub|f><around*|\||x|\<rangle\>>\<otimes\><around*|\||y|\<rangle\>>\<rightarrow\><around*|\||x|\<rangle\>>\<otimes\><around*|\||y\<oplus\>f<around*|(|x|)>|\<rangle\>>>.
  We can convert such an oracle to another <math|U<rsub|w>> as follows :

  <math|<around*|\||x|\<rangle\>>\<otimes\><around*|\||0|\<rangle\>>\<longrightarrow\><around*|[|I\<otimes\>X|]>\<longrightarrow\><around*|\||x|\<rangle\>>\<otimes\><around*|\||1|\<rangle\>>\<longrightarrow\><around*|[|I\<otimes\>H|]>\<longrightarrow\><around*|\||x|\<rangle\>>\<otimes\><around*|(|<frac|<around*|\||0|\<rangle\>>-<around*|\||1|\<rangle\>>|<sqrt|2>>|)>\<longrightarrow\><around*|[|U<rsub|f>|]>\<longrightarrow\>>

  <math|\<longrightarrow\><around*|\||x|\<rangle\>>\<otimes\><around*|(|<frac|<around*|\||f<around*|(|x|)>|\<rangle\>>-<around*|\||1\<oplus\>f<around*|(|x|)>|\<rangle\>>|<sqrt|2>>|)>=<around*|(|-1|)><rsup|f<around*|(|x|)>><around*|\||x|\<rangle\>>\<otimes\><around*|(|<frac|<around*|\||0|\<rangle\>>-<around*|\||1|\<rangle\>>|<sqrt|2>>|)>\<longrightarrow\><around*|[|I\<otimes\><around*|(|X<rsup|-1>
  H<rsup|-1>|)>|]>\<longrightarrow\><around*|(|-1|)><rsup|f<around*|(|x|)>><around*|\||x|\<rangle\>>\<otimes\><around*|\||0|\<rangle\>>>.

  \;

  So <math|U<rsub|w>\<otimes\>I\<equiv\><around*|(|I\<otimes\><around*|(|X
  <rsup|-1>H<rsup|-1>|)>|)>U<rsub|f><around*|(|I\<otimes\><around*|(|H
  X|)>|)>> acts as an oracle that \Precognizes\Q strings <math|x> with
  <math|f<around*|(|x|)>=1> by negating the phase :
  <math|<around*|(|U<rsub|w>\<otimes\>I|)><around*|\||x|\<rangle\>><around*|\||0|\<rangle\>>\<rightarrow\><around*|(|-1|)><rsup|f<around*|(|x|)>><around*|\||x|\<rangle\>><around*|\||0|\<rangle\>>>.
  Assuming for simplicity that <math|f<around*|(|x|)>> is 1 for a single
  string <math|w>. Grover's algorithm starts from a uniform superposition
  <math|<around*|\||s|\<rangle\>>=2<rsup|-n/2><big|sum><rsub|x\<in\>\<bbb-Z\><rsub|2><rsup|n>><around*|\||x|\<rangle\>>>
  and starts increasing the amplitude of <math|<around*|\||w|\<rangle\>>>
  while reducing that of others.

  Rewriting <math|<around*|\||s|\<rangle\>>=2<rsup|-n/2><around*|\||w|\<rangle\>>+<sqrt|<frac|2<rsup|n>-1|2<rsup|n>>><around*|\||s<rprime|'>|\<rangle\>>>
  where the rest of the terms <math|<around*|\||s<rprime|'>|\<rangle\>>=<sqrt|<frac|1|2<rsup|n>-1>><big|sum><rsub|x:f<around*|(|x|)>\<neq\>1><around*|\||x|\<rangle\>>>.

  From its definition, <math|U<rsub|w>=<big|sum><rsub|x:f<around*|(|x|)>\<neq\>1><around*|\||x|\<rangle\>><around|\<langle\>|x|\|>-<around*|\||w|\<rangle\>><around|\<langle\>|w|\|>=I-2<around*|\||w|\<rangle\>><around|\<langle\>|w|\|>>.
  Geometrically, <math|U<rsub|w>> is a reflection about the hyperplane with
  <math|<around*|\||w|\<rangle\>>> as its normal direction, which contains
  the <math|<around*|\||s<rprime|'>|\<rangle\>>> direction. The algorithm
  proceeds by making such successive reflections about
  <math|<around*|\||s|\<rangle\>>> and <math|<around*|\||s<rprime|'>|\<rangle\>>>,
  while never leaving the <math|<around*|\||s<rprime|'>|\<rangle\>>,<around*|\||w|\<rangle\>>>
  plane. The operator <math|U<rsub|s>> depicted below is the Grover diffusion
  operator <math|=2<around*|\||s|\<rangle\>><around|\<langle\>|s|\|>-I>.
  <math|cos<around*|(|\<theta\>/2|)>=<around|\<langle\>|s<rprime|'><around*|\|||\<nobracket\>>s|\<rangle\>>=<sqrt|<frac|2<rsup|n>-1|2<rsup|n>>>>.
  Each pair of reflections cause the state to rotate towards
  <math|<around*|\||w|\<rangle\>>> by an angle <math|\<theta\>>, which brings
  the optimal number of iterations to about
  <math|\<Theta\><around*|(|<sqrt|2<rsup|n>>|)>>. This gives us a quadratic
  speedup over exhaustive search. Measuring the resulting state in
  computational basis produces a feasible string with high probability.

  <\padded-center>
    <image|310px-Grovers_algorithm_geometry.png|108pt|113pt||>

    Grover's algorithm \U geometric view
  </padded-center>

  <subsection|Phase estimation><label|section_qpe>

  Phase estimation is a technique to estimate the eigenvalue <math|e<rsup|2
  \<pi\> i \<varphi\>>> of a unitary operator <math|U>
  <with|font-shape|italic|given its eigenstate>
  <math|<around*|\||x|\<rangle\>>> and store the result as
  <math|\<varphi\>\<in\><around*|[|0,1|)>> accurate up to <math|n> qubits.

  An effecient implementation of phase estimation exists, provided we can
  construct oracles for <math|U<rsup|2<rsup|j>>> (<math|2<rsup|j>>
  applications of <math|U>) effeciently, and can condition those oracles on
  external qubits. It also employs the quantum Fourier transform. We won't go
  into the details, and will only look at the procedure as a black box.

  Given <math|U> and an eigenvector <math|<around|\||x|\<rangle\>>>, i.e
  <math|<around*|\||x|\<rangle\>>> can be prepared effeciently, or is
  available to us, where <math|U <around*|\||x|\<rangle\>>=e<rsup|2
  \<pi\>i\<varphi\>><around*|\||x|\<rangle\>>>, QPE is itself a quantum
  circuit <math|P> that takes <math|n> additional qubits, and acts on
  <math|<around*|\||0|\<rangle\>><rsub|n>\<otimes\><around*|\||x|\<rangle\>>>
  to give <math|<around*|\||<wide|\<varphi\>|~>|\<rangle\>><rsub|n>\<otimes\><around*|\||x|\<rangle\>>>;
  <math|<wide|\<varphi\>|~>> being an approximation <math|2<rsup|n
  >\<varphi\>> to <math|n>-bits.

  Chapter 5 of <cite|mike_and_ike> is a good resource on the quantum Fourier
  transform and quantum phase estimation. QPE applied on specific unitaries
  <math|U> directly result in the famous polynomial time algorithms for
  factoring and the discrete logarithm problem.

  <subsection|Hamiltonian simulation><label|hamiltonian_simulation>

  The earliest motivations of building a quantum computer were the
  realization that a such a device could effeciently simulate quantum
  mechanics much faster than a classical computer. Chapter 4.7 of
  <cite|mike_and_ike> is an excellent introduction to the topic. Hamiltonian
  simulation is a fundamental part of simulating physical systems.

  The general idea is to simulate <math|Schr<math|<wide|o|\<ddot\>>>dinger>
  evolution by approximating the operator <math|e<rsup|-i <wide|H|^>t>> via
  quantum gates. This is hard in general, since <math|<wide|H|^>> could be
  exponentially large.

  Usually, simulation is studied for specific classes of Hamiltonians. E.g
  when <math|<wide|H|^>> is a sum of less complex, more locally acting
  Hamiltonians <math|<big|sum><rsub|k><wide|H|^><rsub|k>>. The heart of
  simulation algorithms for such sums is the Trotter product formula :

  <\padded-center>
    <math|lim<rsub|n\<rightarrow\>\<infty\>><around*|(|e<rsup|i A\<Delta\>
    t/n>e<rsup|i B\<Delta\> t/n>|)>=e<rsup|i<around*|(|A+B|)>\<Delta\>t>>
  </padded-center>

  which is verified by expanding the Taylor series. This is valid even when
  <math|A> and <math|B> don't commute. Note that in general for two matrices
  <math|A> and <math|B> unless <math|A B=B A>, <math|e<rsup|A+B>> need not
  <math|=e<rsup|A>e<rsup|B>>. We can also derive error bounds like so :
  <math|e<rsup|i<around*|(|A+B|)>\<Delta\>t>=e<rsup|i A\<Delta\>t>e<rsup|i
  B\<Delta\>t>+O<around*|(|\<Delta\>t<rsup|2>|)>> which give us approximation
  errors made by our simulation.

  If the unitary transforms <math|e<rsup|-i
  <wide|H<rsub|>|^><rsub|k>\<Delta\>t>> can be effeciently implemented as
  gates, we get an approximation for <math|e<rsup|-i<wide|H|^>\<Delta\>t>>.
  Hamiltonians of the kind <math|H=H<rsub|1>\<otimes\>H<rsub|2>\<ldots\>\<otimes\>H<rsub|k>>,
  also sometimes have effecient gate implementations.

  <cite|Berry_2006> gives an algorithm to effeciently simulate sparse
  Hamiltonians \U ones whose matrix have at most <math|s> non-zero elements
  per row/column. Usually algorithms taking sparse matrices as input assume
  an oracle that takes (<math|r>, <math|i>) indices and returns
  <math|i<rsup|th>> non-zero element of the row <math|r>. <cite|Childs_2009>
  discusses discrete and continuous time quantum random walks on graphs, and
  the correspondance of the two cases leads to an algorithm for effeciently
  simulating certain Hamiltonians. Quantum random walks are interesting in
  their own right, and are further discussed in appendix
  <reference|quantum_random_walks>.

  <section|Adiabatic quantum computation><label|section_adiabat>

  <subsection|The quantum adiabatic algorithm>

  The term <with|font-shape|italic|adiabatic> itself has roots in
  thermodynamics; it refers to processes that don't transfer heat.
  Classically, such reversible processes are also called
  <with|font-shape|italic|isentropic> \U entropy preserving.

  The quantum adiabatic algorithm was first presented by Farhi, Goldstone,
  Gutmann and Sipser in <cite|qc_adiabat>. QAA works with
  <with|font-shape|italic|time-dependent> Hamiltonians
  <math|<wide|H|^><around*|(|t|)>>. The analysis of time resource
  requirements for the algorithm relies on the
  <with|font-shape|italic|quantum adiabatic theorem>. In it's original form
  it states \U <with|font-shape|italic|a physical system remains in its
  instantaneous eigenstate if a given perturbation is acting on it slowly
  enough, and if there is a gap between the given eigenvalue and the rest of
  the energy spectrum.>

  The system evolves as given by the <math|Schr<math|<wide|o|\<ddot\>>>dinger>
  equation <math|i \<hbar\><frac|d|d t><around*|\||\<psi\><around*|(|t|)>|\<rangle\>>=<wide|H|^><around*|(|t|)><around*|\||\<psi\><around*|(|t|)>|\<rangle\>>>.
  For some smooth family of Hamiltonians <math|<around*|{|<wide|H|^><around*|(|t|)>:0\<leqslant\>t\<leqslant\>T|}>>,
  denote the instantaneous eigenstates/eigenvalues as
  <math|<wide|H|^><around*|(|t|)><around*|\||l;t|\<rangle\>>=E<rsub|l><around*|(|t|)><around*|\||l;t|\<rangle\>>>,
  where <math|E<rsub|l><around*|(|t|)>> is the <math|l<rsup|th>> energy level
  at time <math|t> : <math|E<rsub|0><around*|(|t|)>\<leqslant\>E<rsub|1><around*|(|t|)>\<leqslant\>\<cdots\>\<leqslant\>E<rsub|N-1><around*|(|t|)>>.
  According to the adiabatic theorem, a system in the ground state at time 0
  <math|<around*|\||\<psi\><around*|(|0|)>|\<rangle\>>=<around*|\||0;0|\<rangle\>>>
  stays in the ground state provided <math|T> is suffeciently large (i.e the
  process is suffeciently slow.) More concretely,
  <math|lim<rsub|T\<rightarrow\>\<infty\>><around|\<langle\>|l=0,t=T<around*|\||\<psi\><around*|(|T|)>|\<nobracket\>>
  |\<rangle\>>=1>.

  As noted in <cite|qc_adiabat>, for <math|g<rsub|min>\<equiv\>min<rsub|0\<leqslant\>t\<leqslant\>T><around*|{|E<rsub|1><around*|(|t|)>-E<rsub|0><around*|(|t|)>|}>>
  (the smallest spectral gap), <math|T\<gtr\>\<Theta\><around*|(|1/g<rsub|min><rsup|2>|)>>
  suffices. Intuitively, the smaller the spectral gap, the more likely it is
  to accidentally transition from the ground state. The trick then is to
  construct Hamiltonians <math|H<rsub|B>> and <math|H<rsub|P>> on
  <math|n>-qubit systems that have desired ground eigenstates.
  <math|H<rsub|B>> has a ground state that is easily found and prepared, and
  the ground state of <math|H<rsub|P>> encodes the solution to a problem of
  interest, and <math|<wide|H|^><around*|(|t|)>=H<rsub|B><around*|(|1-t/T|)>+t
  H<rsub|P>/T>.

  <cite|qc_adiabat> proceeds to show how we can encode binary constraint
  satisfaction problems as Hamiltonians, and how the above
  <math|Schr<math|<wide|o|\<ddot\>>>dinger> evolution gives a final state
  <math|<around*|\||\<psi\><around*|(|T|)>|\<rangle\>>> maximizing the number
  of satisfied clauses. The problem with using adiabatic computation to solve
  NP problems is that one usually finds the spectral gap <math|g<rsub|min>>
  to be exponentially small in problem size <math|N>, making
  <math|T\<in\>\<Omega\><around*|(|exp<around*|(|\<alpha\>
  N<rsup|\<beta\>>|)>|)>>. So, while it's unlikely that QAA might solve NP
  problems exponentially faster than classical algorithms, the constants
  <math|\<alpha\>> and <math|\<beta\>> might be smaller than classically
  possible.

  <subsection|The Ising model, and quadratic binary optimization>

  A particular kind of physical system whose Hamiltonian is of interest, is
  the one described by the Ising model. It was originally conceived to study
  magnetism arising out of interacting spins in nearby atoms in a metallic
  lattice. The configuration of such systems is given by a graph
  <math|G<around*|(|V,E|)>> of spin sites <math|V> and adjacent interacting
  pairs of sites <math|E>. The (classical) Hamiltonian for this graphical
  model takes the form <math|H<around*|(|\<sigma\>|)>=-<big|sum><rsub|<around*|(|i,j|)>\<in\>E>J<rsub|i
  j>\<sigma\><rsub|i>\<sigma\><rsub|j>-\<mu\><big|sum><rsub|i\<in\>V>h<rsub|i>\<sigma\><rsub|i>>,
  <math|\<sigma\>\<in\><around*|{|+1,-1|}><rsup|<around*|\||V|\|>>>. Clearly,
  for <math|\<mu\>=0>, the cut <math|<around*|{|i:\<chi\><rsub|i>=+1|}>> for
  <math|\<chi\>\<in\>argmin<rsub|\<sigma\>>H<around*|(|\<sigma\>|)>> is a
  solution to a weighted max-cut instance. A quantum version of such a
  Hamiltonian, encoding this and other NP-hard problems, is given in
  <cite|Lucas_2014>.

  The class of quadratic unconstrained binary optimizations (QUBO) that seek
  to find <math|argmin<rsub|x\<in\>\<bbb-Z\><rsub|2><rsup|n>><around*|{|x<rsup|T>Q
  x|}>>, for symmetric <math|n\<times\>n> matrices
  <math|Q\<in\>\<bbb-S\><rsub|n>> also falls under this paradigm, as they are
  computationally equivalent to the Ising model. Solving this class of
  problems by quantum annealing is one of the main intended uses of some
  adiabatic quantum computers. (One such computer is supposedly right here at
  USC.) Although, quantum annealing might not be exactly the same as
  implementing the adiabatic algorithm as mentioned above, the two are
  closely related. It's important to note is that this model of computation
  is equivalent <cite|adeqstd> to the standard gate model discussed earlier.\ 

  <subsection|A variational approximation algorithm>

  While QAA aims to solve problems exactly, there do exist families of
  quantum circuits that can approximate a solution. Farhi, Goldstone and
  Gutmann <cite|qaoa> present an approximation scheme (QAOA) that takes a
  parameter <math|p>, and constructs a circuit with depth scaling linearly
  with <math|p>, that gives increasingly good approximations for max-SAT
  instances. QAOA is an example of a <with|font-shape|italic|variational
  algorithm>. It applies a specific unitary transform
  <math|U<around*|(|\<beta\>,\<gamma\>|)>> parametrized by
  <math|\<beta\>,\<gamma\>\<in\>\<bbb-R\><rsup|p>> to generate a state
  <math|U<around*|(|\<beta\>,\<gamma\>|)><around*|\||\<psi\><rsub|0>|\<rangle\>>\<rightarrow\><around*|\||\<psi\><around*|(|\<beta\>,\<gamma\>|)>|\<rangle\>>>.
  The goal is to find optimal parameters <math|<around*|(|\<beta\><rsup|\<star\>>,\<gamma\><rsup|\<star\>>|)>>
  using classical optimizers such that <math|<around*|\||\<psi\><around*|(|\<beta\><rsup|\<star\>>,\<gamma\><rsup|\<star\>>|)>|\<rangle\>>>
  encodes the approximate optimal solution.

  <math|U<around*|(|\<beta\>,\<gamma\>|)>> has a specific form :
  <math|U<around*|(|\<beta\>,\<gamma\>|)>=<big|prod><rsub|j\<in\><around*|[|p|]>>e<rsup|-i
  \<beta\><rsub|j>H<rsub|B>>e<rsup|-i\<gamma\><rsub|j>H<rsub|P>>>. The
  Hamiltonians <math|H<rsub|B>> and <math|H<rsub|P>> have the same ground
  states as they do in QAA, and are also called the
  <with|font-shape|italic|mixing> and <with|font-shape|italic|problem>
  Hamiltonians respectively. The convergence guarantee when
  <math|p\<rightarrow\>\<infty\>> follows from the fact that larger circuits
  more closely approximate the adiabatic evolution.

  The algorithm proceeds by initializing the parameters
  <math|<around*|(|\<beta\>,\<gamma\>|)>> and repeatedly updating them. This
  update is done by preparing <math|<around*|\||\<psi\><around*|(|\<beta\>,\<gamma\>|)>|\<rangle\>>>
  using the above unitaries (which are assumed to have effecient gate
  implementations) and calculating the expectation
  <math|<around|\<langle\>|\<psi\><around*|(|\<beta\>,\<gamma\>|)><around*|\||H<rsub|P>|\|>\<psi\><around*|(|\<beta\>,\<gamma\>|)>|\<rangle\>>>.
  Then a classical optimizer is used to find a new set of parameters
  <math|<around*|(|\<gamma\><rprime|'>,\<beta\><rprime|'>|)>> for the next
  step. The choice of optimizer varies between exact applications. Note that
  the optimizer doesn't have access to <math|\<beta\>,\<gamma\>> gradients,
  and must use some gradient-free methods.

  This paradigm of hybrid quantum-classical computation using variational
  algorithms has gained a lot of traction recently, especially since the
  advent of the so called variational quantum eigensolver (VQE)
  <cite|Peruzzo_2014> for estimating the smallest (ground-state) eigenvalue,
  which has applications in chemistry and physics. One of the advantages of
  such methods is their applicability on already available, noisy,
  intermediate scale quantum computers that have limited coherence times and
  fault tolerance.

  <section|The HHL algorithm for solving linear systems><label|section_hhl>

  Harrow, Hassidim and Lloyd <cite|Harrow_2009> exhibit a quantum algorithm,
  denoted as the HHL algorithm, to solve <math|N\<leqslant\>2<rsup|n>>
  dimensional linear systems of the form <math|A x=b>. We will briefly
  discuss the overview of the algorithm and then go over some its
  applications and limitations. One of the broad ideas in quantum algorithms
  involving matrices is to consider them as Hamiltonians, and build circuits
  resembling them. HHL is an example of this.

  <subsection|The algorithm>

  The HHL algorithm encodes vectors <math|b> and <math|x> by normalizing and
  mapping them to quantum states <math|<around*|\||b|\<rangle\>>> and
  <math|<around*|\||x|\<rangle\>>>. This is done by creating the state
  <math|<around*|\||b|\<rangle\>>=<big|sum><rsub|i\<in\>\<bbb-Z\><rsub|2><rsup|n>>b<rsub|i><around*|\||i|\<rangle\>>>,
  i.e the components are stored as amplitudes. If <math|A> is not Hermitian,
  the algorithm works on solving <math|<matrix|<tformat|<table|<row|<cell|0>|<cell|A>>|<row|<cell|A<rsup|\<dagger\>>>|<cell|0>>>>>y=<matrix|<tformat|<table|<row|<cell|b>>|<row|<cell|0>>>>>>
  to obtain <math|y=<matrix|<tformat|<table|<row|<cell|0>>|<row|<cell|x>>>>>>,
  hence <math|A> is assumed Hermitian w.l.o.g. <math|A> then has a
  decomposition <math|A=<big|sum><rsub|j>\<lambda\><rsub|j><around*|\||u<rsub|j>|\<rangle\>><around|\<langle\>|u<rsub|j>|\|>>
  with <math|\<lambda\><rsub|j>> as eigenvalues for eigenvectors
  <math|<around*|\||u<rsub|j>|\<rangle\>>>. Rewriting
  <math|<around*|\||b|\<rangle\>>> in that eigenbasis as
  <math|<around*|\||b|\<rangle\>>=<big|sum><rsub|j>\<beta\><rsub|j><around*|\||u<rsub|j>|\<rangle\>>>,
  we have <math|<around*|\||x|\<rangle\>>=A<rsup|-1><around*|\||b|\<rangle\>>=<big|sum><rsub|j>\<lambda\><rsub|j><rsup|-1>\<beta\><rsub|j><around*|\||u<rsub|j>|\<rangle\>>>,
  which is the state HHL computes.

  To do so, HHL works with the unitary <math|U=e<rsup|i A
  t>=<big|sum><rsub|j>e<rsup|i \<lambda\><rsub|j>t><around*|\||u<rsub|j>|\<rangle\>><around|\<langle\>|u<rsub|j>|\|>>,
  and uses techniques of Hamiltonian simulation from <cite|Berry_2006>,
  <cite|Childs_2009> to implement <math|e<rsup|i A t>>. Using quantum phase
  estimation (section <reference|section_qpe>) with <math|U>, it prepares the
  state <math|<big|sum><rsub|j>\<beta\><rsub|j><around*|\||<wide|\<lambda\><rsub|j>|~>|\<rangle\>><around*|\||u<rsub|j>|\<rangle\>>>.
  (Approximately. Since the eigenvalues are not always exact, an in-depth
  analysis takes care of inaccurate phase estimation and its effect on the
  final state, which is expressed as a double sum in the paper.) Here
  <math|<wide|\<lambda\><rsub|j>|~>> is an <math|n-bit> binary approximation
  of <math|\<lambda\><rsub|j>/2\<pi\>>. If <math|\<lambda\><rsub|j>>s are
  large, we can always scale the entire system.

  Next, on an auxiliary qubit, a rotation conditional on
  <math|<around*|\||<wide|\<lambda\><rsub|j>|~>|\<rangle\>>> is applied,
  which results in the state

  <math|<big|sum><rsub|j>\<beta\><rsub|j><around*|\||<wide|\<lambda\><rsub|j>|~>|\<rangle\>><around*|\||u<rsub|j>|\<rangle\>><around*|\||0|\<rangle\>>\<longrightarrow\><big|sum><rsub|j>\<beta\><rsub|j><around*|\||<wide|\<lambda\><rsub|j>|~>|\<rangle\>><around*|\||u<rsub|j>|\<rangle\>><around*|{|<sqrt|1-<frac|C<rsup|2>|<wide|\<lambda\><rsub|j>|~><rsup|2>>><around*|\||0|\<rangle\>>+<frac|C|<wide|\<lambda\><rsub|j>|~>><around*|\||1|\<rangle\>>|}>>.
  Then the auxiliary qubit is measured until it's observed to collapse to
  <math|<around*|\||1|\<rangle\>>>, causing the resulting state to be
  <math|<frac|1|Z><big|sum><rsub|j>C\<beta\><rsub|j><wide|\<lambda\><rsub|j><rsup|>|~><rsup|-1><around*|\||<wide|\<lambda\><rsub|j>|~>|\<rangle\>><around*|\||u<rsub|j>|\<rangle\>><around*|\||1|\<rangle\>>>,
  where the normalization factor <math|Z=<sqrt|<big|sum><rsub|k><around*|\||\<beta\><rsub|k><rsup|2>|\|><around*|\||C<rsup|2>|\|>/<around*|\||<wide|\<lambda\>|~><rsub|k><rsup|2>|\|>>>
  is estimated by the probability of observing
  <math|<around*|\||1|\<rangle\>>>. This is the desired state up to a
  normalization <math|C/Z>.

  The running time of the algorithm is lower bounded by the success
  probability of observing <math|<around*|\||1|\<rangle\>>>, which in turn
  depends on <math|<around*|\||C|\|>\<in\>O<around*|(|1/\<kappa\>|)>>. And
  the phase estimation error translates to a final error <math|\<epsilon\>>.
  A rudimentary analysis shows that the running time is
  <math|<wide|O|~><around*|(|log<around*|(|N|)>s<rsup|2>\<kappa\><rsup|3>/\<epsilon\>|)>>
  for <math|s>-sparse matrices. An extra factor of <math|\<kappa\>> can be
  saved by amplitude amplification (section <reference|section_ampl>).

  <subsection|Applications and limitations>

  The conception of the HHL algorithm sparked a \Pmini-revolution\Q in the
  field of quantum machine learning. Suddenly there was renewed interest in
  solving practical problems like least squares fitting, classification and
  clustering using this exponentially faster algorithm. Similar algorithms
  with related ideas started popping up. This included solving linear
  differential equations <cite|Berry_2014_diffeq>, and various tasks in
  machine learning <cite|qml> and data fitting <cite|Wiebe_2012>.

  As aptly put in <cite|qml_rtfp>, HHL is not
  <with|font-shape|italic|exactly> an algorithm for solving linear equations
  <math|A x=b> in logarithmic time. Rather, it's an algorithm for
  approximately preparing a quantum superposition
  <math|<around*|\||x|\<rangle\>>>. The paper also goes on to discuss its
  limitations, in that HHL guarantees an exponential speedup only when (1)
  the state <math|<around*|\||b|\<rangle\>>> can be loaded quickly in the
  quantum computer's memory, (2) the unitary <math|e<rsup|-i A t>> is
  effeciently implemented as a quantum circuit, and <math|A> is sparse (3)
  <math|A> is <with|font-shape|italic|well-conditioned>, i.e its condition
  number <math|\<kappa\>=<around*|\||\<lambda\><rsub|max>|\|>/<around*|\||\<lambda\><rsub|min>|\|>>
  is small; note that classical algorithms like the conjugate gradient method
  also prefer well-conditioned matrices. (As
  <math|\<lambda\><rsub|min>\<rightarrow\>0>, the balls are mapped to
  ellipsoids that become more and more oblong, until they are flat in some
  direction.) (4) Simply writing <math|x> requires linear time, however HHL
  produces <math|<around*|\||x|\<rangle\>>> in logarithmically many qubits.
  The algorithm is useful if we can utilize <math|<around*|\||x|\<rangle\>>>
  and may not be when we definitely need <math|x>. <cite|qml_rtfp> further
  shows that despite these limitations, there exist potential applications of
  HHL.

  <cite|fastlinsolv> improves on HHL by giving an algorithm that generalizes
  amplitude amplification, and uses it to give an improved algorithm for
  solving linear systems in <math|<wide|O|~><around*|(|\<kappa\> log<rsup|3>
  \<kappa\> log <around*|(|N|)> poly<around*|(|1/\<epsilon\>|)>|)>>.

  <cite|Childs_2017> improves on HHL by giving an algorithm with runtime
  <math|O<around*|(|log<around*|(|1/\<epsilon\>|)>|)>>. However, as noted in
  the paper, if the output <math|<around*|\||x|\<rangle\>>> is needed to
  sample expectations of the kind <math|<around|\<langle\>|x<around*|\||M|\|>x|\<rangle\>>>,
  the sampling error alone rules out a <math|poly<around*|(|log<around*|(|1/\<epsilon\>|)>|)>>
  time algorithm. Still, this is useful when used as a subroutine being
  called polynomially many times.

  <section|Semidefinite programming><label|section_sdp>

  A semidefinite program (SDP) is a special case of a convex program, with
  numerous applications in a variety of topics ranging from operations
  research to combinatorial optimization. SDPs also generalize linear
  programs. They are an indespensible tool when it comes to the development
  of approximation algorithms for NP-hard optimization problems, the most
  famous of which has to be the SDP relaxation of the max cut problem
  <cite|maxcut_sdp> by Goemans and Williamson.

  The popular classical algorithms for solving SDPs are mostly based on
  numerical primal-dual methods like the interior point method
  <cite|Boyd2004-hu>, which work by applying Newton-Raphson iterations on a
  pair of (primal, dual) vectors to minimize a barrier function. These
  methods are bottlenecked by the need to store and invert a large block
  matrix of Hessians and Jacobians. There also exist other first order
  methods.

  For our purposes, however, we'll start with a seemingly unrelated framework
  of the <with|font-shape|italic|multiplicative weights> (MW) algorithm. This
  meta-algorithm has been rediscovered multiple times in different fields
  ranging from machine learning to game theory to constrained optimization.
  Arora, Kale and Hazan <cite|mwa> give a great survey on this framework, and
  our discussion will be based on it. This will eventually lead us to a
  primal-dual method for solving SDPs <cite|mmw_sdp>. Lastly, we'll gently
  scratch the surface of a quantum algorithm presented in <cite|qsdp> which
  is based on these ideas.

  <subsection|The multiplicative weights algorithm>

  As introduced in <cite|mwa>, MW is a generalization of the
  <with|font-shape|italic|weighted majority> algorithm which solves the
  <with|font-shape|italic|prediction from expert advice> problem. In this
  problem, we have <math|n> experts, each giving a binary bit of advice; will
  it or won't it rain today, for example; on every time step for predicting a
  global observation. The weighted majority algorithm starts by giving an
  equal weight to every expert. Everyday, it makes decisions based on the
  weighted sum of the experts' advice, and then penalizes all of the experts
  that gave the wrong advice that day, by halving their weight. We can prove
  that the number of mistakes it makes is bounded above by twice the number
  of mistakes made by the best expert, plus additive factors.

  In the general randomized setting, there are a set of <math|n> choices, for
  each of the <math|T> rounds, and we are required to make a single choice on
  every round. After we make that choice, the costs associated with making
  the decision at time <math|t> are revealed as a vector
  <math|m<rsup|<around*|(|t|)>>>. Our objective is to compute a distribution
  <math|p<rsup|<around*|(|t|)>>> over the set of decisions at every time
  step, so that the expectation <math|<big|sum><rsub|t\<in\><around*|[|T|]>><big|sum><rsub|i\<in\><around*|[|n|]>>p<rsup|<around*|(|t|)>><rsub|i>m<rsub|i><rsup|<around*|(|t|)>>=<big|sum><rsub|t\<in\><around*|[|T|]>><around*|(|p<rsup|<around*|(|t|)>>,m<rsup|<around*|(|t|)>>|)>>
  is close to the cost of a single best decision
  \ <math|min<rsub|i><big|sum><rsub|t\<in\>T>m<rsub|i><rsup|<around*|(|t|)>>>
  we could have made in hindsight. The algorithm quite simply maintains a
  weight function <math|w<rsup|<around*|(|t|)>>\<in\>\<bbb-R\><rsup|n>> of
  the decisions at every time step, and declares
  <math|p<rsup|<around*|(|t|)>>\<equiv\>w<rsup|<around*|(|t|)>>/\<Phi\><rsup|<around*|(|t|)>>>,
  where <math|\<Phi\><rsup|<around*|(|t|)>>\<equiv\><big|sum><rsub|i\<in\><around*|[|n|]>>w<rsup|<around*|(|t|)>><rsub|i>>.
  After every decision, the weights are <with|font-shape|italic|multiplicatively
  updated> to suppress costly choices.

  <\algorithm>
    Initialize : Fix <math|0\<less\>\<eta\>\<leqslant\>1/2>, and set
    <math|w<rsup|<around*|(|1|)>>=<with|font-series|bold|1>>

    <math|\<longrightarrow\>\<forall\>t\<in\><around*|[|T|]>>:
    <math|p<rsup|<around*|(|t|)>>\<longleftarrow\>w<rsup|<around*|(|t|)>>/\<Phi\><rsup|<around*|(|t|)>>>.
    Use this distribution to sample a choice

    <math|\<longrightarrow\>> observe <math|m<rsup|<around*|(|t|)>>>, and
    penalize costly decisions: <math|w<rsub|i><rsup|<around*|(|t+1|)>>\<longleftarrow\>w<rsub|i><rsup|<around*|(|t|)>><around*|(|1-\<eta\>
    m<rsub|i><rsup|<around*|(|t|)>>|)>>
  </algorithm>

  Assuming all costs <math|<around*|\||m<rsub|i><rsup|<around*|(|t|)>>|\|>\<leqslant\>1>,
  the MW algorithm guarantees that after <math|T> rounds, for any decision
  <math|i\<in\><around*|[|n|]>>, the following bound holds :

  <\padded-center>
    <math|<big|sum><rsub|t\<in\><around*|[|T|]>><around*|(|m<rsup|<around*|(|t|)>>,p<rsup|<around*|(|t|)>>|)>\<leqslant\><big|sum><rsub|t\<in\>T>m<rsub|i><rsup|<around*|(|t|)>>+\<eta\><big|sum><rsub|t\<in\>T><around*|\||m<rsub|i><rsup|<around*|(|t|)>>|\|>+<frac|ln<around*|(|n|)>|\<eta\>>>

    <math|\<Longrightarrow\>><math|<big|sum><rsub|t\<in\><around*|[|T|]>><around*|(|m<rsup|<around*|(|t|)>>,p<rsup|<around*|(|t|)>>|)>\<leqslant\><big|sum><rsub|t\<in\>T><around*|(|m<rsup|<around*|(|t|)>>+\<eta\><around*|\||m<rsup|<around*|(|t|)>>|\|>,p|)>+<frac|ln<around*|(|n|)>|\<eta\>>>
  </padded-center>

  Note that the factor of two from the deterministic setting is now dropped
  to one. As noted in <cite|mwa>, the Hedge algorithm <cite|adaboost> of
  Freund and Schapire is a variation of MW, except the weights are updated
  with an exponential multiplicative factor :

  <\padded-center>
    <math|w<rsub|i><rsup|<around*|(|t+1|)>>\<longleftarrow\>w<rsub|i><rsup|<around*|(|t|)>>e<rsup|-\<eta\>m<rsub|i><rsup|<around*|(|t|)>>>>
  </padded-center>

  to obtain a similar looking regret bound (using
  <math|e<rsup|-\<eta\>x>\<leqslant\>1-\<eta\>x+\<eta\><rsup|2>x<rsup|2><space|1em>\<forall\><around*|\||\<eta\>
  x|\|>\<leqslant\>1>):

  <\padded-center>
    <math|\<forall\>i\<in\><around*|[|n|]>:<big|sum><rsub|t\<in\><around*|[|T|]>><around*|(|m<rsup|<around*|(|t|)>>,p<rsup|<around*|(|t|)>>|)>\<leqslant\><big|sum><rsub|t\<in\>T>m<rsub|i><rsup|<around*|(|t|)>>+\<eta\><big|sum><rsub|t\<in\>T><around*|{|<big|sum><rsub|j\<in\><around*|[|n|]>><around*|(|m<rsub|j><rsup|<around*|(|t|)>>|)><rsup|2>p<rsub|j><rsup|<around*|(|t|)>>|}>+<frac|ln<around*|(|n|)>|\<eta\>>>
  </padded-center>

  The authors of <cite|adaboost> go on to apply this to their
  <math|G<math|<wide|o|\<ddot\>>>del> award winning conception of AdaBoost.

  <subsection|Multiplicative weights as constructive LP duals>

  <cite|mwa> show the connection between MW and LPs by giving the example of
  learning a separating hyperplane classifier. This is a classic task in
  machine learning. As they note, the following can be regarded as a
  \Pconstructive\Q version of LP duality. When solving constrained
  optimization problems, each decision represents a constraint, with costs
  representing the corresponding potential function. Iteratively re-weighting
  these costs can now be seen as a game-theoretic version of Lagrangian
  optimization.

  Suppose we are given <math|m> points of labelled data
  <math|<around*|(|x<rsub|i>,y<rsub|i>|)>>,
  <math|x<rsub|i>\<in\>\<bbb-R\><rsup|n>,y<rsub|i>\<in\><around*|{|\<pm\>1|}>>,
  and our objective is to find a separating hyperplane <math|w> satisfying
  <math|sign<around*|(|<around*|(|w,x<rsub|i>|)>|)>=y<rsub|i>>, or
  equivalently <math|<around*|(|y<rsub|i>x<rsub|i>,w|)>\<geqslant\>0> for all
  <math|x<rsub|i>>. Assuming w.l.o.g, <math|w\<in\>\<Delta\><rsup|n>>, where
  <math|\<Delta\><rsup|n>> is the probability simplex
  <math|<around*|{|\<alpha\>\<in\>\<bbb-R\><rsup|n>:<big|sum><rsub|i>\<alpha\><rsub|i>=1,\<alpha\>\<succcurlyeq\>0|}>>,
  and renaming <math|y<rsub|i>x<rsub|i>=z<rsub|i>>, the problem reduces to an
  LP feasibility problem <math|\<exists\>?w\<in\>\<Delta\><rsup|n>:\<forall\>j\<in\><around*|[|m|]><around*|(|z<rsub|j>,w|)>\<geqslant\>0>.

  Assuming that there is a large margin solution; i.e
  <math|\<exists\>\<varepsilon\>\<gtr\>0,w<rsup|\<star\>>:\<forall\>j\<in\><around*|[|m|]>:<around*|(|z<rsub|j>,w<rsup|\<star\>>|)>\<geqslant\>\<varepsilon\>>,
  MW can be used to solve this as follows. Define
  <math|\<rho\>\<equiv\>max<rsub|j><around*|\<\|\|\>|z<rsub|j>|\<\|\|\>><rsub|\<infty\>>>,
  and set <math|\<eta\>\<longleftarrow\>\<varepsilon\>/2\<rho\>>, and set the
  costs as <math|m<rsub|i><rsup|<around*|(|j|)>>=<around*|(|z<rsub|j>|)><rsub|i>/\<rho\>>.
  (<math|<around*|\||m<rsub|i><rsup|<around*|(|j|)>>|\|>\<leqslant\>1>)

  In each round <math|t>, we let <math|w> to be the distribution
  <math|p<rsup|<around*|(|t|)>>> generated by MW, and look at an unsatisfied
  constraint (a misclassified example) <math|j>, and use
  <math|m<rsup|<around*|(|j|)>>> for weight update. We keep doing this until
  we find a feasible point. As shown in <cite|mwa>, we can safely terminate
  after <math|<around*|\<lceil\>|4\<rho\><rsup|2>
  log<around*|(|n|)>/\<varepsilon\><rsup|2>|\<rceil\>>> iterations.

  <subsection|The matrix multiplicative weights algorithm>

  The MW algorithm can be extended to get a version that solves SDP
  feasibility (and hence by convexity, optimization) using a similar
  exponential weight update rule.

  The decisions now correspond to unit vectors
  <math|v<rsup|<around*|(|t|)>>\<in\>\<bbb-R\><rsup|n>,v<rsup|<around*|(|t|)>><rsup|T>v<rsup|<around*|(|t|)>>=1>.
  The costs are given as a matrix <math|M<rsup|<around*|(|t|)>>\<in\>\<bbb-R\><rsup|n\<times\>n>>,
  and the cost of each decision is <math|v<rsup|<around*|(|t|)>><rsup|T>M<rsup|<around*|(|t|)>>
  v<rsup|<around*|(|t|)>>>. Just like before, we assume all singular values
  of <math|M<rsup|<around*|(|t|)>>> are <math|\<leqslant\>1>. The objective
  at each time step is to compute a distribution
  <math|\<cal-D\><rsup|<around*|(|t|)>>> over our choices, such that the
  expected cost <math|<big|sum><rsub|t>\<bbb-E\><rsub|v\<sim\>\<cal-D\><rsup|<around*|(|t|)>>><around*|[|v<rsup|<around*|(|t|)>T>M<rsup|<around*|(|t|)>>v<rsup|<around*|(|t|)>>|]>>
  is close to the best fixed decision <math|v<rsup|T><around*|(|<big|sum><rsub|t\<in\>T>M<rsup|<around*|(|t|)>>|)>v>,
  which is just the smallest eigenvalue of
  <math|<big|sum><rsub|t\<in\>T>M<rsup|<around*|(|t|)>>>.

  Denote the inner product on symmetric matrices
  <math|C,X\<in\>\<bbb-S\><rsub|n>> as <math|<around|\<langle\>|C,X|\<rangle\>>=Tr<around*|[|C
  X|]>=<big|sum><rsub|i j>C<rsub|i j>X<rsub|i j>>, where
  <math|Tr<around*|[|.|]>> is the trace operator.
  <math|\<bbb-E\><rsub|v\<sim\>\<cal-D\><rsup|<around*|(|t|)>>><around*|[|v<rsup|<around*|(|t|)>T>M<rsup|<around*|(|t|)>>v<rsup|<around*|(|t|)>>|]>=\<bbb-E\><rsub|v\<sim\>\<cal-D\><rsup|<around*|(|t|)>>><around*|[|Tr<around*|[|v<rsup|<around*|(|t|)>T>M<rsup|<around*|(|t|)>>v<rsup|<around*|(|t|)>>|]>|]>=\<bbb-E\><rsub|v\<sim\>\<cal-D\><rsup|<around*|(|t|)>>><around*|[|Tr<around*|[|M<rsup|<around*|(|t|)>>v<rsup|<around*|(|t|)>>v<rsup|<around*|(|t|)>T>|]>|]>=Tr<around*|[|M<rsup|<around*|(|t|)>>\<bbb-E\><rsub|v\<sim\>\<cal-D\><rsup|<around*|(|t|)>>><around*|[|v<rsup|<around*|(|t|)>>v<rsup|<around*|(|t|)>T>|]>|]>><math|=<around|\<langle\>|M<rsup|<around*|(|t|)>>,\<bbb-E\><rsub|v\<sim\>\<cal-D\><rsup|<around*|(|t|)>>><around*|[|v<rsup|<around*|(|t|)>>v<rsup|<around*|(|t|)>T>|]>|\<rangle\>>>.

  Denote <math|\<bbb-E\><rsub|v\<sim\>\<cal-D\><rsup|<around*|(|t|)>>><around*|[|v<rsup|<around*|(|t|)>>v<rsup|<around*|(|t|)>T>|]>=P<rsup|<around*|(|t|)>>>.
  It's easy to see that <math|P<rsup|<around*|(|t|)>>\<succcurlyeq\>0,Tr<around*|[|P<rsup|<around*|(|t|)>>|]>=1>.
  <math|P<rsup|<around*|(|t|)>>> is a hence a density matrix (appendix
  <reference|density_operator>). And it's exactly what MMW computes at each
  step. Any distribution <math|\<cal-D\><rsup|<around*|(|t|)>>> with this
  density suffices. The eigendecomposition of <math|P<rsup|<around*|(|t|)>>>
  gives one such discrete distribution.

  <\algorithm>
    Initialize : Fix <math|0\<less\>\<eta\>\<leqslant\>1/2>, and set
    <math|W<rsup|<around*|(|1|)>>=I>

    <math|\<longrightarrow\>\<forall\>t\<in\><around*|[|T|]>>:
    <math|P<rsup|<around*|(|t|)>>\<longleftarrow\>W<rsup|<around*|(|t|)>>/\<Phi\><rsup|<around*|(|t|)>>>,
    with <math|\<Phi\><rsup|<around*|(|t|)>>\<equiv\>Tr<around*|[|W<rsup|<around*|(|t|)>>|]>>.

    <math|\<longrightarrow\>> observe <math|M<rsup|<around*|(|t|)>>>, and
    update weights as : <math|W<rsub|i><rsup|<around*|(|t+1|)>>\<longleftarrow\>W<rsub|i><rsup|<around*|(|t|)>>e<rsup|-\<eta\>M<rsup|<around*|(|t|)>>>>
  </algorithm>

  Using an additional inequality <math|Tr<around*|[|e<rsup|A+B>|]>\<leqslant\>Tr<around*|[|e<rsup|A>e<rsup|B>|]>>,
  we have a matrix version of the familiar regret bound:
  <math|\<forall\>v\<in\>\<bbb-R\><rsup|n>,v<rsup|T>v=1>

  <\padded-center>
    <math|<big|sum><rsub|t\<in\><around*|[|T|]>><around|\<langle\>|M<rsup|<around*|(|t|)>>,P<rsup|<around*|(|t|)>>|\<rangle\>>\<leqslant\><big|sum><rsub|t\<in\><around*|[|T|]>>v<rsup|T>M<rsup|<around*|(|t|)>>v+\<eta\><rsup|2><big|sum><rsub|t\<in\><around*|[|T|]>><around|\<langle\>|<around*|(|M<rsup|<around*|(|t|)>>|)><rsup|2>,P<rsup|<around*|(|t|)>>|\<rangle\>>+<frac|ln<around*|(|n|)>|\<eta\>>>
  </padded-center>

  We'll consider the following form of feasibility:<math|\<exists\>?X\<in\>\<Delta\><rsub|n><rsup|n>:\<forall\>j\<in\><around*|[|m|]>
  <around|\<langle\>|A<rsub|j>,X|\<rangle\>>\<geqslant\>0>, where
  <math|\<Delta\><rsub|n><rsup|n>> is the set of density matrices
  <math|<around*|{|X\<in\>\<bbb-S\><rsub|n>:Tr<around*|[|X|]>=1,X\<succcurlyeq\>0|}>>.
  (This shape is also called a <with|font-shape|italic|spectrahedron>.) When
  all matrices are diagonal, this is the same is LP feasibility discussed
  earlier.

  Assuming there is a large margin solution:
  <math|\<exists\>\<varepsilon\>\<gtr\>0 s.t>
  <math|<around|\<langle\>|A<rsub|j>,X|\<rangle\>>\<geqslant\>\<varepsilon\>>,
  and defining <math|\<rho\>\<leftarrow\>max<rsub|j><around*|\<\|\|\>|A<rsub|j>|\<\|\|\>>>
  (largest operator norm), setting <math|\<eta\>\<longleftarrow\>\<varepsilon\>/2\<rho\>>
  and the costs as <math|M<rsup|<around*|(|t|)>>=A<rsub|j>/\<rho\>> for some
  unsatisfied constraint <math|j>, we run the same procedure, to get an
  exactly analogous algorithm. The running time is again bounded by
  <math|<around*|\<lceil\>|4\<rho\><rsup|2>
  log<around*|(|n|)>/\<varepsilon\><rsup|2>|\<rceil\>>>.

  <subsection|A fast approximate primal-dual algorithm for SDPs>

  We'll now briefly discuss the faster version of this algorithm presented in
  <cite|mmw_sdp>. The primal SDP is :\ 

  <\padded-center>
    <math|max<around|\<langle\>|C,X|\<rangle\>> s.t
    \<forall\>j\<in\><around*|[|m|]>:<around|\<langle\>|A<rsub|j>,X|\<rangle\>>\<leqslant\>b<rsub|j>,X\<succcurlyeq\>0>
  </padded-center>

  and its dual is

  <\padded-center>
    <math|min <around|\<langle\>|b,y|\<rangle\>> s.t
    <big|sum><rsub|j\<in\><around*|[|m|]>>y<rsub|j>A<rsub|j>\<succcurlyeq\>C,y\<succcurlyeq\>0>
  </padded-center>

  Optimization is reduced to feasibility using binary search. Assume
  <math|A<rsub|1>=I,b<rsub|1>=R\<Longrightarrow\>Tr<around*|[|X|]>\<leqslant\>R>,
  which serves as a bound for binary search. Every feasibility subproblem is
  to construct either a primal feasible PSD matrix <math|X> with value
  <math|\<gtr\>\<alpha\>>, or a dual feasible vector <math|y> with value
  <math|\<leqslant\>\<alpha\><around*|(|1+\<delta\>|)>> for arbitrarily small
  <math|\<delta\>\<gtr\>0>. The algorithm mimics MMW by generating iterates
  <math|X<rsup|<around*|(|t|)>>> over <math|1\<leqslant\>t\<leqslant\>T> time
  steps. At the center of this algorithm is an oracle <math|\<cal-O\>> which
  is used to generate these iterates. <math|\<cal-O\>> tries to find a dual
  vector <math|y\<in\>D<rsub|\<alpha\>>=<around*|{|y:y\<succcurlyeq\>0:<around|\<langle\>|b,y|\<rangle\>>\<leqslant\>\<alpha\>|}>>
  subject to the constraints <math|<big|sum><rsub|j\<in\><around*|[|m|]>><around|\<langle\>|A<rsub|j>,X<rsup|<around*|(|t|)>>|\<rangle\>>y<rsub|j>-<around|\<langle\>|C,X<rsup|<around*|(|t|)>>|\<rangle\>>\<geqslant\>0>.
  Note that this is an LP with a single non-trivial constraint.

  If there is no such <math|y\<in\>D<rsub|\<alpha\>>>, we have a feasible
  <math|X> with value <math|\<geqslant\>\<alpha\>>. And if <math|\<cal-O\>>
  succeeds in finding such a <math|y>, <math|X<rsup|<around*|(|t|)>>> is
  either primal infeasible or has value <math|\<leqslant\>\<alpha\>>. The
  algorithm's progress is measured using the <with|font-shape|italic|width
  property> <math|\<rho\>> of the oracle <math|\<cal-O\>>:
  <math|\<rho\>\<equiv\>sup<rsub|y\<in\>D<rsub|\<alpha\>>><around*|\<\|\|\>|<big|sum><rsub|j>y<rsub|j>A<rsub|j>-C|\<\|\|\>>>
  (<math|<around*|\<\|\|\>|.|\<\|\|\>>> denotes operator norm)

  \;

  The authors of <cite|mmw_sdp> prove that if algorithm <reference|mmw_sdp>
  proceeds for <math|T\<geqslant\><frac|8\<rho\><rsup|2>R<rsup|2>ln<around*|(|n|)>|\<delta\><rsup|2>\<alpha\><rsup|2>>>
  iterations, then <math|y<rsup|\<star\>>\<equiv\><frac|\<delta\>\<alpha\>|R><with|font-series|bold|e><rsub|1>+<frac|1|T><big|sum><rsub|t\<in\><around*|[|T|]>>y<rsup|<around*|(|t|)>>>
  is a dual feasible solution with objective at most
  <math|<around*|(|1+\<delta\>|)>\<alpha\>>. Thus, we get a feasibility
  subroutine that we can use inside the binary search. Note that <math|R>
  must be known <with|font-shape|italic|a priori>. Moreover they obtain fast
  approximation algorithms for several optimization problems, including one
  for the SDP relaxation of max-cut.

  <\algorithm>
    <label|mmw_sdp>Initialize: <math|W<rsup|<around*|(|1|)>>\<leftarrow\>I>,
    <math|\<varepsilon\>\<longleftarrow\>\<delta\>\<alpha\>/2\<rho\>R>,
    <math|\<varepsilon\><rprime|'>\<longleftarrow\>-ln<around*|(|1-\<varepsilon\>|)>>

    <\math>
      \<forall\>t\<in\><around*|[|T|]>:
    </math>

    Define <math|X<rsup|<around*|(|t|)>>\<equiv\>R
    W<rsup|<around*|(|t|)>>/Tr<around*|[|W<rsup|<around*|(|t|)>>|]>>

    Invoke <math|\<cal-O\><around*|(|X<rsup|<around*|(|t|)>>|)>> to get
    <math|y<rsup|<around*|(|t|)>>>. If it fails, stop and output
    <math|X<rsup|<around*|(|t|)>>> as a feasible solution with value
    <math|\<gtr\>\<alpha\>>

    else, set the MMW \Pcosts\Q as <math|M<rsup|<around*|(|t|)>>\<longleftarrow\><around*|(|<big|sum><rsub|j\<in\><around*|[|m|]>>A<rsub|j>y<rsub|j><rsup|<around*|(|t|)>>-C+\<rho\>I|)>/2\<rho\>>

    and update the weights as <math|W<rsup|<around*|(|t+1|)>>\<longleftarrow\>W<rsup|<around*|(|t|)>>e<rsup|-\<varepsilon\><rprime|'>M<rsup|<around*|(|t|)>>>>
  </algorithm>

  <subsection|A quantum algorithm for solving SDPs>

  <cite|qsdp> gives a quantum algorithm based on the matrix multiplicative
  weights method, with a claimed worst-case running time of
  <math|\<Theta\><around*|(|<sqrt|n m>s<rsup|2>poly<around*|(|log<around*|(|n|)>,log<around*|(|n|)>,R,r,1/\<delta\>|)>|)>>.
  As before, parameter <math|R> is an upper bound on <math|Tr<around*|[|X|]>>
  for primal feasible <math|X>. The authors also reduce the dual SDP to the
  case where <math|b\<succcurlyeq\><with|font-series|bold|1>>, <math|r> is an
  upper bound on <math|<with|font-series|bold|1><rsup|T>b>. <math|\<delta\>>
  is an additive error tolerance for the dual solution as before. Note
  however that the running time analyses show the algorithm to be
  prohibitively costly in terms of <math|R> and <math|\<delta\>>. The authors
  also believe that this can be mitigated significantly.

  Of course, simply writing the optimal primal/dual takes
  <math|\<Omega\><around*|(|min<around*|(|n<rsup|2>, m|)>|)>> time, so the
  problem is framed instead as the following : given
  <math|A<rsub|1>,A<rsub|2>\<ldots\>A<rsub|m>,A<rsub|m+1>\<equiv\>C>
  approximate the optimal value of the above primal and/or dual SDPs. The
  quantum algorithm is also required to produce an estimate of
  <math|<around*|\<\|\|\>|y|\<\|\|\>><rsub|1>> and/or
  <math|Tr<around*|[|X|]>>, and also be able to generate samples from the
  <with|font-shape|italic|distribution> <math|p\<equiv\>y/<around*|\<\|\|\>|y|\<\|\|\>><rsub|1>>
  and/or from the density <math|\<rho\>\<equiv\>X/Tr<around*|[|X|]>>. Like in
  HHL, the matrices are taken to be <math|s>-sparse, and are given by an
  oracle that takes indices <math|j\<in\><around*|[|m+1|]>,k\<in\><around*|[|n|]>,l\<in\><around*|[|s|]>>
  and compute the <math|l<rsup|th>> non-zero element <math|nz<rsub|j
  k><around*|(|l|)>> of the <math|k<rsup|th>> row of <math|A<rsub|j>> as :
  <math|<around*|\||j,k,l,z|\<rangle\>>\<longrightarrow\><around*|\||j,k,l,z\<oplus\>nz<rsub|j
  k><around*|(|l|)>|\<rangle\>>>.

  One of the main ideas in <cite|qsdp> is to use \PGibbs samplers\Q \U
  quantum circuits that given such an oracle <math|O<rsub|H>> for the entries
  of a an <math|s>-sparse Hamiltonian <math|H> produce a state
  <math|<around*|\||\<psi\>|\<rangle\>>> with density resembling a Gibbs
  state <math|<around*|\||\<psi\>|\<rangle\>><around|\<langle\>|\<psi\>|\|>\<approx\>e<rsup|H>/Tr<around*|[|e<rsup|H>|]>>.
  \ Gibbs sampling is a widely studied topic, the most prominent example of
  which is the work on a quantum version of the Metropolis algorithm
  <cite|Temme_2011>, <cite|Yung_2012>.

  The authors noticed that applying amplitude amplification (section
  <reference|section_ampl>) to Gibbs samplers straightaway gives a quadratic
  speedup w.r.t <math|n>. In fact, if the Gibbs sampler has some really nice
  properties, we can get even exponential speedups. Furthermore, they claim
  that replacing the oracle <math|\<cal-O\>> of <cite|mmw_sdp> with such
  samplers is also possible, and gives a quadratic speedup w.r.t <math|m>.

  The main contribution can thus be summarized as follows: using these
  samplers allows us to quickly compute the multiplicative weight updates,
  hence the quantum speedup. Several improvements have since been proposed
  <cite|qsdp2>, <cite|van_Apeldoorn_2020>.

  <section|Summary>

  We explored some quantum algorithms encountered in combinatorial and
  constrained optimization. The reader must have noticed the importance of
  Hamiltonians (section <reference|hamiltonian_simulation>) in constructing
  quantum algorithms that handle matrices. Which is why we have some
  additional discussions in appendix <reference|quantum_random_walks> on a
  connection between Hamiltonians and quantum random walks. Hamiltonians with
  sparse entries in particular are the ones that are amenable to quantum
  speedups.

  Something worth emphasizing is the interdisciplinary nature of the
  discussed topics. Most of these developments wouldn't have been possible if
  not for the collaboration between people working in different fields,
  ranging from theoretical computer science, to physics, to engineering. This
  has to inspire awe in anyone interested in quantum computing.

  The author hopes that this paper serves as a good starting point for
  exploring optimization algorithms from a quantum point of view, and thanks
  the reader for their interest.

  <page-break>

  <\bibliography|bib|tm-plain|refs>
    <\bib-list|36>
      <bibitem*|1><label|bib-qml_rtfp>Scott Aaronson. <newblock>Read the fine
      print. <newblock><with|font-shape|italic|Nature Physics>, 11:291\U293,
      04 2015.<newblock>

      <bibitem*|2><label|bib-qwalk_graphs>Dorit Aharonov, Andris Ambainis,
      Julia Kempe<localize|, and >Umesh Vazirani. <newblock>Quantum walks on
      graphs. <newblock>2000.<newblock>

      <bibitem*|3><label|bib-adeqstd>Dorit Aharonov, Wim van<nbsp>Dam, Julia
      Kempe, Zeph Landau, Seth Lloyd<localize|, and >Oded Regev.
      <newblock>Adiabatic quantum computation is equivalent to standard
      quantum computation. <newblock>2004.<newblock>

      <bibitem*|4><label|bib-fastlinsolv>Andris Ambainis. <newblock>Variable
      time amplitude amplification and a faster quantum algorithm for solving
      systems of linear equations. <newblock>2010.<newblock>

      <bibitem*|5><label|bib-mwa>Sanjeev Arora, Elad Hazan<localize|, and
      >Satyen Kale. <newblock>The multiplicative weights update method: a
      meta-algorithm and applications. <newblock><with|font-shape|italic|Theory
      of Computing>, 8(6):121\U164, 2012.<newblock>

      <bibitem*|6><label|bib-mmw_sdp>Sanjeev Arora<localize| and >Satyen
      Kale. <newblock>A combinatorial, primal-dual approach to semidefinite
      programs. <newblock><with|font-shape|italic|J. ACM>, 63(2), may
      2016.<newblock>

      <bibitem*|7><label|bib-axler>Sheldon<nbsp>Jay Axler.
      <newblock><with|font-shape|italic|Linear Algebra Done Right>.
      <newblock>Undergraduate Texts in Mathematics. Springer, New York,
      1997.<newblock>

      <bibitem*|8><label|bib-revcomp>C.<nbsp>H.<nbsp>Bennett.
      <newblock>Logical reversibility of computation.
      <newblock><with|font-shape|italic|IBM Journal of Research and
      Development>, 17(6):525\U532, 1973.<newblock>

      <bibitem*|9><label|bib-Berry_2014_diffeq>Dominic<nbsp>W Berry.
      <newblock>High-order quantum algorithm for solving linear differential
      equations. <newblock><with|font-shape|italic|Journal of Physics A:
      Mathematical and Theoretical>, 47(10):105301, feb 2014.<newblock>

      <bibitem*|10><label|bib-Berry_2006>Dominic<nbsp>W.<nbsp>Berry, Graeme
      Ahokas, Richard Cleve<localize|, and >Barry<nbsp>C.<nbsp>Sanders.
      <newblock>Efficient quantum algorithms for simulating sparse
      hamiltonians. <newblock><with|font-shape|italic|Communications in
      Mathematical Physics>, 270(2):359\U371, dec 2006.<newblock>

      <bibitem*|11><label|bib-Boyd2004-hu>Stephen Boyd<localize| and >Lieven
      Vandenberghe. <newblock><with|font-shape|italic|Convex Optimization>.
      <newblock>Cambridge University Press, Cambridge, England, mar
      2004.<newblock>

      <bibitem*|12><label|bib-qsdp2>Fernando<nbsp>G.<nbsp>S.<nbsp>L.<nbsp>Brandão,
      Amir Kalev, Tongyang Li, Cedric<nbsp>Yen-Yu Lin,
      Krysta<nbsp>M.<nbsp>Svore<localize|, and >Xiaodi Wu. <newblock>Quantum
      sdp solvers: large speed-ups, optimality, and applications to quantum
      learning. <newblock>2017.<newblock>

      <bibitem*|13><label|bib-qsdp>Fernando<nbsp>G.<nbsp>S.<nbsp>L.<nbsp>Brandao<localize|
      and >Krysta Svore. <newblock>Quantum speed-ups for semidefinite
      programming. <newblock>2016.<newblock>

      <bibitem*|14><label|bib-Brassard_2002>Gilles Brassard, Peter Høyer,
      Michele Mosca<localize|, and >Alain Tapp. <newblock>Quantum amplitude
      amplification and estimation. <newblock>2002.<newblock>

      <bibitem*|15><label|bib-Childs_2009>Andrew<nbsp>M.<nbsp>Childs.
      <newblock>On the relationship between continuous- and discrete-time
      quantum walk. <newblock><with|font-shape|italic|Communications in
      Mathematical Physics>, 294(2):581\U603, oct 2009.<newblock>

      <bibitem*|16><label|bib-Childs_2002>Andrew<nbsp>M.<nbsp>Childs, Edward
      Farhi<localize|, and >Sam Gutmann. <newblock><with|font-shape|italic|Quantum
      Information Processing>, 1(1/2):35\U43, 2002.<newblock>

      <bibitem*|17><label|bib-Childs_2017>Andrew<nbsp>M.<nbsp>Childs, Robin
      Kothari<localize|, and >Rolando<nbsp>D.<nbsp>Somma. <newblock>Quantum
      algorithm for systems of linear equations with exponentially improved
      dependence on precision. <newblock><with|font-shape|italic|SIAM Journal
      on Computing>, 46(6):1920\U1950, jan 2017.<newblock>

      <bibitem*|18><label|bib-solovay_kitaev_algorithm>Christopher<nbsp>M.<nbsp>Dawson<localize|
      and >Michael<nbsp>A.<nbsp>Nielsen. <newblock>The solovay-kitaev
      algorithm. <newblock><with|font-shape|italic|Quantum Info. Comput.>,
      6(1):81\U95, jan 2006.<newblock>

      <bibitem*|19><label|bib-qaoa>Edward Farhi, Jeffrey Goldstone<localize|,
      and >Sam Gutmann. <newblock>A quantum approximate optimization
      algorithm. <newblock>2014.<newblock>

      <bibitem*|20><label|bib-qc_adiabat>Edward Farhi, Jeffrey Goldstone, Sam
      Gutmann<localize|, and >Michael Sipser. <newblock>Quantum computation
      by adiabatic evolution. <newblock>2000.<newblock>

      <bibitem*|21><label|bib-Farhi_1998>Edward Farhi<localize| and >Sam
      Gutmann. <newblock>Quantum computation and decision trees.
      <newblock><with|font-shape|italic|Physical Review A>, 58(2):915\U928,
      aug 1998.<newblock>

      <bibitem*|22><label|bib-adaboost>Yoav Freund<localize| and
      >Robert<nbsp>E Schapire. <newblock>A decision-theoretic generalization
      of on-line learning and an application to boosting.
      <newblock><with|font-shape|italic|Journal of Computer and System
      Sciences>, 55(1):119\U139, 1997.<newblock>

      <bibitem*|23><label|bib-maxcut_sdp>Michel<nbsp>X.<nbsp>Goemans<localize|
      and >David<nbsp>P.<nbsp>Williamson. <newblock>Improved approximation
      algorithms for maximum cut and satisfiability problems using
      semidefinite programming. <newblock><with|font-shape|italic|J. ACM>,
      42(6):1115\U1145, nov 1995.<newblock>

      <bibitem*|24><label|bib-Grover_1998>Lov<nbsp>K.<nbsp>Grover.
      <newblock>Quantum computers can search rapidly by using almost any
      transformation. <newblock><with|font-shape|italic|Physical Review
      Letters>, 80(19):4329\U4332, may 1998.<newblock>

      <bibitem*|25><label|bib-Harrow_2009>Aram<nbsp>W.<nbsp>Harrow, Avinatan
      Hassidim<localize|, and >Seth Lloyd. <newblock>Quantum algorithm for
      linear systems of equations. <newblock><with|font-shape|italic|Physical
      Review Letters>, 103(15), oct 2009.<newblock>

      <bibitem*|26><label|bib-Kempe_2003>J Kempe. <newblock>Quantum random
      walks: an introductory overview. <newblock><with|font-shape|italic|Contemporary
      Physics>, 44(4):307\U327, jul 2003.<newblock>

      <bibitem*|27><label|bib-heat>R.<nbsp>Landauer.
      <newblock>Irreversibility and heat generation in the computing process.
      <newblock><with|font-shape|italic|IBM Journal of Research and
      Development>, 5(3):183\U191, 1961.<newblock>

      <bibitem*|28><label|bib-qml>Seth Lloyd, Masoud Mohseni<localize|, and
      >Patrick Rebentrost. <newblock>Quantum algorithms for supervised and
      unsupervised machine learning. <newblock>2013.<newblock>

      <bibitem*|29><label|bib-Lucas_2014>Andrew Lucas. <newblock>Ising
      formulations of many NP problems. <newblock><with|font-shape|italic|Frontiers
      in Physics>, 2, 2014.<newblock>

      <bibitem*|30><label|bib-mike_and_ike>Michael<nbsp>A Nielsen<localize|
      and >Isaac<nbsp>L Chuang. <newblock><with|font-shape|italic|Quantum
      Computation and Quantum Information>. <newblock>Cambridge University
      Press, Cambridge, England, dec 2010.<newblock>

      <bibitem*|31><label|bib-Peruzzo_2014>Alberto Peruzzo, Jarrod McClean,
      Peter Shadbolt, Man-Hong Yung, Xiao-Qi Zhou, Peter<nbsp>J.<nbsp>Love,
      Alán Aspuru-Guzik<localize|, and >Jeremy<nbsp>L.<nbsp>O'Brien.
      <newblock>A variational eigenvalue solver on a photonic quantum
      processor. <newblock><with|font-shape|italic|Nature Communications>,
      5(1), jul 2014.<newblock>

      <bibitem*|32><label|bib-Temme_2011>K.<nbsp>Temme,
      T.<nbsp>J.<nbsp>Osborne, K.<nbsp>G.<nbsp>Vollbrecht,
      D.<nbsp>Poulin<localize|, and >F.<nbsp>Verstraete. <newblock>Quantum
      metropolis sampling. <newblock><with|font-shape|italic|Nature>,
      471(7336):87\U90, mar 2011.<newblock>

      <bibitem*|33><label|bib-van_Apeldoorn_2020>Joran van<nbsp>Apeldoorn,
      Andrá<nbsp>s Gilyén, Sander Gribling<localize|, and >Ronald
      de<nbsp>Wolf. <newblock>Quantum SDP-Solvers: better upper and lower
      bounds. <newblock><with|font-shape|italic|Quantum>, 4:230, feb
      2020.<newblock>

      <bibitem*|34><label|bib-Wiebe_2012>Nathan Wiebe, Daniel
      Braun<localize|, and >Seth Lloyd. <newblock>Quantum algorithm for data
      fitting. <newblock><with|font-shape|italic|Physical Review Letters>,
      109(5), aug 2012.<newblock>

      <bibitem*|35><label|bib-qcintro>Noson<nbsp>S.<nbsp>Yanofsky.
      <newblock>An introduction to quantum computing.
      <newblock>2007.<newblock>

      <bibitem*|36><label|bib-Yung_2012>Man-Hong Yung<localize| and
      >Alá<nbsp>n Aspuru-Guzik. <newblock>A quantum\Uquantum metropolis
      algorithm. <newblock><with|font-shape|italic|Proceedings of the
      National Academy of Sciences>, 109(3):754\U759, jan 2012.<newblock>
    </bib-list>
  </bibliography>

  <appendix|Density operators><label|density_operator>

  There is an alternate formulation <cite|mike_and_ike> of the postulates
  which ascribe quantum systems with a <with|font-shape|italic|density
  operator> <math|\<rho\>> acting on the corresponding Hilbert space. For
  <with|font-shape|italic|pure> states <math|<around*|\||\<psi\>|\<rangle\>>>,
  the density operator is given by <math|\<rho\>\<equiv\><around*|\||\<psi\>|\<rangle\>><around|\<langle\>|\<psi\>|\|>>.
  The advantage in using the density operator formalism is its ability to
  describe <with|font-shape|italic|ensembles> of pure states. Physical
  systems with exactly the state <math|<around*|\||\<psi\>|\<rangle\>>> are
  difficult to prepare, and we might have to work with a system having state
  <math|<around*|\||\<psi\><rsub|i>|\<rangle\>>> with probabilities
  <math|p<rsub|i>>. The ensemble <math|<around*|{|p<rsub|i>,<around*|\||\<psi\><rsub|i>|\<rangle\>>|}>>
  is defined to have density <math|\<rho\>\<equiv\><big|sum><rsub|i>p<rsub|i><around*|\||\<psi\><rsub|i>|\<rangle\>><around|\<langle\>|\<psi\><rsub|i>|\|>>.
  A state is hence <with|font-shape|italic|pure> when only one of the
  <math|p<rsub|i>s> is 1.

  E.g consider a qubit we know to have either state
  <math|<around*|\||0|\<rangle\>>> or <math|<around*|\||1|\<rangle\>>> with
  1/2 probability. The density is then <math|<frac|1|2><matrix|<tformat|<table|<row|<cell|1>|<cell|0>>|<row|<cell|0>|<cell|1>>>>>>.
  Notice that this isn't the same as saying the qubit is in the pure
  superposition state <math|<frac|<around*|\||0|\<rangle\>>+<around*|\||1|\<rangle\>>|<sqrt|2>>>,
  which has density <math|<frac|1|2><matrix|<tformat|<table|<row|<cell|1>|<cell|1>>|<row|<cell|1>|<cell|1>>>>>>.
  Densities are characterized by positive definite operators with trace 1.
  Different ensembles can give rise to the same density operator, which is
  what ultimately governs measurement statistics.

  Analogous to the <math|Schr<math|<wide|o|\<ddot\>>>dinger> equation
  \ <math|i \<hbar\><frac|d|d t><around*|\||\<psi\><around*|(|t|)>|\<rangle\>>=<wide|H|^><around*|\||\<psi\><around*|(|t|)>|\<rangle\>>>
  describing time evolution of state vectors, the von Neumann equation
  <math|i\<hbar\><frac|\<partial\>\<rho\>|\<partial\>t>=<around*|[|<wide|H|^>,\<rho\>|]>>
  describes time evolution of densities. Here
  <math|<around*|[|<wide|H|^>,\<rho\>|]>> denotes the commutator
  <math|<wide|H|^>\<rho\>-\<rho\><wide|H|^>>. As expected, for time
  independent Hamiltonians <math|\<rho\><around*|(|t|)>=e<rsup|-i
  <wide|H|^>t/\<hbar\>>\<rho\><around*|(|0|)>e<rsup|i <wide|H|^>t/\<hbar\>>>.
  I.e a unitary transform <math|U> maps densities as:
  <math|\<rho\>\<longrightarrow\>U\<rho\>U<rsup|\<dagger\>>>.

  <new-page*><appendix|Quantum random walks ><label|quantum_random_walks>

  Random walks are powerful tools when it comes to analyzing and designing
  randomized algorithms. Quantum random walks sometimes have an advantage
  over classical random walks. A great introductory survey on this topic is
  <cite|Kempe_2003>, and our discussion will be based around it. This section
  is in the appendix because of the arguably tangential nature of this topic.

  Classical random walks are quite invaluable in theoretical computer
  science. They provide a general paradigm for sampling from exponentially
  large spaces. Important properties of random walks that affect their usage
  in algorithms are their mixing times and hitting times <cite|qwalk_graphs>.
  Quantum random walks behave quite differently than their classical
  counterparts in these regards, which explains their role in obtaining
  faster quantum algorithms. We'll go over some basics of quantum random
  walks. We'll also glance over a connection between random walks and
  Hamiltonians.

  <subsection|A discrete quantum random walk>

  As an example, we'll briefly analyse the simplest of discrete random walks.
  Consider the state of a quantum particle varying over two properties \U its
  \Pspin\Q <math|<around*|{|\<uparrow\>,\<downarrow\>|}>>, and its position
  on a 1D lattice : <math|\<bbb-Z\>>. The spin state of an arbitrary
  superposition is hence a vector in <math|\<cal-H\><rsub|S>=<around*|{|\<alpha\><around*|\||\<uparrow\>|\<rangle\>>+\<beta\><around*|\||\<downarrow\>|\<rangle\>>:\<alpha\>,\<beta\>\<in\>\<bbb-C\>,<around*|\||\<alpha\>|\|><rsup|2>+<around*|\||\<beta\>|\|><rsup|2>=1|}>>.
  Similarly, the superpositions over positions are vectors in
  <math|\<cal-H\><rsub|P>=<around*|{|<big|sum><rsub|x\<in\>\<bbb-Z\>>\<alpha\><rsub|x><around*|\||x|\<rangle\>>:<big|sum><rsub|x><around*|\||\<alpha\><rsub|x>|\|><rsup|2>=1|}>>.
  The complete state description of the particle is a vector
  <math|<around*|\||s|\<rangle\>>\<otimes\><around*|\||p|\<rangle\>>\<in\>\<cal-H\><rsub|S>\<otimes\>\<cal-H\><rsub|P>>.

  Define the \Pcoin-flip operator\Q <math|C\<equiv\>H\<otimes\>I>, <math|H>
  being the familiar Hadamard; and \Pconditional-shift operator\Q
  <math|S=<around*|\||\<uparrow\>|\<rangle\>><around|\<langle\>|\<uparrow\>|\|>\<otimes\><big|sum><rsub|x\<in\>\<bbb-Z\>><around*|\||x+1|\<rangle\>><around|\<langle\>|x|\|>+<around*|\||\<downarrow\>|\<rangle\>><around|\<langle\>|\<downarrow\>|\|>\<otimes\><big|sum><rsub|x\<in\>\<bbb-Z\>><around*|\||x-1|\<rangle\>><around|\<langle\>|x|\|>>.
  The particle jumps right if its spin is up, and left if down:
  <math|S<around*|(|<around*|\||\<uparrow\>/\<downarrow\>|\<rangle\>>\<otimes\><around*|\||x|\<rangle\>>|)>=<around*|(|<around*|\||\<uparrow\>/\<downarrow\>|\<rangle\>>\<otimes\><around*|\||x\<pm\>1|\<rangle\>>|)>>.

  <\big-figure>
    <image|qrandwalk.png|200pt|200pt||><image|qsymwalk.png|200pt|200pt||>

    <space|3em>(a) An asymmetric quantum walk<space|3em><space|4em>(b) A
    symmetric walk.
  <|big-figure>
    Simulations of the discrete quantum random walk<label|qwalk_plots>
  </big-figure>

  For a particle in superposition, <math|S> acts linearly, and the resulting
  amplitudes may add or cancel each other. Consider <math|T> alternate
  applications of <math|S> and <math|C> applied to an initial state
  <math|<around*|\||\<downarrow\>|\<rangle\>>>; measuring the position after
  each time step collapses the state to a definite displacement <math|x>. The
  resulting behaviour is identical to the familiar classical random walk with
  the resulting statistics resmbling the Gaussian approximation of the
  binomial distribution. I.e for large <math|T> the variance scales as
  <math|\<sigma\><rsup|2>\<sim\>T>, while the mean is 0.

  However, if we don't measure the position at every step, the interferences
  over all possible paths after <math|T> steps produce a probability
  distribution over <math|\<bbb-Z\>> that can be skewed, and can even be
  bimodal . The distribution in figure <reference|qwalk_plots> (a) is a
  result of <math|<around*|(|S C|)><rsup|T><around*|(|<around*|\||\<downarrow\>|\<rangle\>>\<otimes\><around*|\||0|\<rangle\>>|)>>.
  <math|C> is asymmetric, and prefers <math|<around*|\||\<downarrow\>|\<rangle\>>>.
  Figure <reference|qwalk_plots> (b) shows the symmteric results of
  <math|<around*|(|S C|)><rsup|T><around*|(|<around*|(|<frac|<around*|\||\<uparrow\>|\<rangle\>>+i<around*|\||\<downarrow\>|\<rangle\>>|<sqrt|2>>|)>\<otimes\><around*|\||0|\<rangle\>>|)>>.
  It can be shown that this quantum walk has a variance that scales as
  <math|\<sigma\><rsup|2>\<sim\>T<rsup|2>>.

  <subsection|Continuous time random walks>

  Viewing <math|\<bbb-Z\>> as line graph, we can generalize the above to
  arbitrary graphs to some extent. <cite|Kempe_2003> cites some studies in
  this regard, and discusses it in some detail. The procedure of coin
  flipping and measuring is not really needed for continuous time random
  processes.

  \;

  Borrowing the following from Wikipedia, we analyze a single spin-free
  quantum particle with mass <math|m> and a 1D freedom of position <math|x>.
  Its position at time <math|t> being completely determined by the wave
  function <math|\<psi\><around*|(|x,t|)>> satisfying the zero-potential
  <math|Schr<math|<wide|o|\<ddot\>>>dinger> equation : <math|i \<hbar\>
  <frac|\<partial\>\<psi\>|\<partial\>t>=<frac|<wide|p|^><rsup|2><rsup|>\<psi\>|2m>>,
  where <math|<wide|p|^>=-i \<hbar\> <frac|\<partial\>\<psi\>|\<partial\>x>>
  is the 1D momentum observable. <math|\<Rightarrow\>i \<hbar\>
  <frac|\<partial\>\<psi\>|\<partial\>t>=<frac|-\<hbar\><rsup|2>|2m><frac|\<partial\><rsup|2>\<psi\>|\<partial\>x<rsup|2>>>.

  \;

  Discretizing <math|x> as <math|\<bbb-Z\><rsub|\<Delta\>x>\<equiv\><around*|{|\<ldots\>,-2\<Delta\>x,-\<Delta\>x,0,\<Delta\>x,2\<Delta\>x,\<ldots\>|}>>,
  the double derivative is replaced by <math|<frac|\<partial\><rsup|2>\<psi\>|\<partial\>x<rsup|2>>\<rightarrow\><frac|\<psi\><around*|(|<around*|(|j+1|)>\<Delta\>x,t|)>-2\<psi\><around*|(|j\<Delta\>x,t|)>+\<psi\><around*|(|<around*|(|j-1|)>\<Delta\>x,t|)>|\<Delta\>x<rsup|2>>\<equiv\><frac|L<rsub|\<bbb-Z\>>\<psi\><around*|(|j\<Delta\>x,t|)>|\<Delta\>x<rsup|2>>>,
  giving us the evolution law :

  <math|i<frac|\<partial\>\<psi\>|\<partial\>t>=-\<omega\><rsub|\<Delta\>x>
  L<rsub|\<bbb-Z\><rsub|\<Delta\>x>>\<psi\>>.
  <math|\<omega\><rsub|\<Delta\>x>\<equiv\><frac|\<hbar\>|2m\<Delta\>x<rsup|2>>>
  is a constant, and <math|L<rsub|\<bbb-Z\><rsub|\<Delta\>x>>> is the
  <with|font-shape|italic|Laplacian> of the line graph
  <math|\<bbb-Z\><rsub|\<Delta\>x>>.

  For arbitrary graphs <math|G<around*|(|V,E|)>>, the graph Laplacian is
  defined as <math|L<rsub|G>\<equiv\>D<rsub|G>-A<rsub|G>>, with
  <math|D<rsub|G>> the degree matrix (diagonal of degrees) and
  <math|A<rsub|G>> the adjacency matrix.

  \;

  In continuous time random walks on graph <math|G>, the evolution law is
  given <math|<frac|\<partial\>\<psi\>|\<partial\>t>=-i \<omega\>
  L<rsub|G>\<psi\>>, where the <math|\<omega\>L<rsub|G>> itself acts as the
  Hamiltonian <cite|Kempe_2003> with the unitary
  <math|U<around*|(|t|)>=e<rsup|-i \<omega\> L<rsub|G>t>>. This was the key
  idea of Farhi and Gutmann <cite|Farhi_1998>, which they use to study
  decision trees, effectively considering quantum computing as a continuous
  time random walk. Furthermore, <cite|Childs_2002> exhibits a finite graph
  with an exponential separation in <with|font-shape|italic|expected hitting
  times>.

  There are a few issues with defining hitting and mixing times in quantum
  vs. classical walks. Consider the fact that any classical random walk on a
  finite graph approaches a stationary distribution
  <math|p<rsup|<around*|(|t|)>>> regardless of the initial distribution
  <math|p<rsup|<around*|(|0|)>>> \U it effectively \Ploses memory\Q. This is
  not possible for reversible unitary transforms. <cite|Kempe_2003> explains
  how we can still analyze such dynamics, using the
  <with|font-shape|italic|Ces<math|<wide|a|\<grave\>>>ro average>
  distribution instead : <math|c<rsup|<around*|(|t|)>>\<equiv\><big|sum><rsub|\<tau\>\<leqslant\>s>p<rsup|<around*|(|\<tau\>|)>>>
  for some <math|0\<less\>s\<leqslant\>t> chosen uniformly at random.
</body>

<\initial>
  <\collection>
    <associate|font|roman>
    <associate|font-base-size|11>
    <associate|font-family|rm>
    <associate|math-font|roman>
    <associate|page-medium|paper>
    <associate|page-screen-margin|false>
  </collection>
</initial>

<\references>
  <\collection>
    <associate|auto-1|<tuple|1|1>>
    <associate|auto-10|<tuple|3|5>>
    <associate|auto-11|<tuple|3.1|5>>
    <associate|auto-12|<tuple|3.2|6>>
    <associate|auto-13|<tuple|3.3|6>>
    <associate|auto-14|<tuple|4|7>>
    <associate|auto-15|<tuple|4.1|7>>
    <associate|auto-16|<tuple|4.2|7>>
    <associate|auto-17|<tuple|4.3|8>>
    <associate|auto-18|<tuple|5|8>>
    <associate|auto-19|<tuple|5.1|8>>
    <associate|auto-2|<tuple|2|1>>
    <associate|auto-20|<tuple|5.2|9>>
    <associate|auto-21|<tuple|6|9>>
    <associate|auto-22|<tuple|6.1|10>>
    <associate|auto-23|<tuple|6.2|11>>
    <associate|auto-24|<tuple|6.3|11>>
    <associate|auto-25|<tuple|6.4|12>>
    <associate|auto-26|<tuple|6.5|13>>
    <associate|auto-27|<tuple|7|13>>
    <associate|auto-28|<tuple|7|14>>
    <associate|auto-29|<tuple|A|15>>
    <associate|auto-3|<tuple|2.1|1>>
    <associate|auto-30|<tuple|B|16>>
    <associate|auto-31|<tuple|B.1|16>>
    <associate|auto-32|<tuple|2|16>>
    <associate|auto-33|<tuple|B.2|17>>
    <associate|auto-4|<tuple|2.2|2>>
    <associate|auto-5|<tuple|2.2.1|2>>
    <associate|auto-6|<tuple|2.2.2|3>>
    <associate|auto-7|<tuple|1|3>>
    <associate|auto-8|<tuple|2.2.3|4>>
    <associate|auto-9|<tuple|2.3|4>>
    <associate|bib-Berry_2006|<tuple|10|14>>
    <associate|bib-Berry_2014_diffeq|<tuple|9|14>>
    <associate|bib-Boyd2004-hu|<tuple|11|14>>
    <associate|bib-Brassard_2002|<tuple|14|14>>
    <associate|bib-Childs_2002|<tuple|16|14>>
    <associate|bib-Childs_2009|<tuple|15|14>>
    <associate|bib-Childs_2017|<tuple|17|14>>
    <associate|bib-Farhi_1998|<tuple|21|14>>
    <associate|bib-Grover_1998|<tuple|24|14>>
    <associate|bib-Harrow_2009|<tuple|25|14>>
    <associate|bib-Kempe_2003|<tuple|26|14>>
    <associate|bib-Lucas_2014|<tuple|29|15>>
    <associate|bib-Peruzzo_2014|<tuple|31|15>>
    <associate|bib-Temme_2011|<tuple|32|15>>
    <associate|bib-Wiebe_2012|<tuple|34|15>>
    <associate|bib-Yung_2012|<tuple|36|15>>
    <associate|bib-adaboost|<tuple|22|14>>
    <associate|bib-adeqstd|<tuple|3|14>>
    <associate|bib-axler|<tuple|7|14>>
    <associate|bib-fastlinsolv|<tuple|4|14>>
    <associate|bib-heat|<tuple|27|14>>
    <associate|bib-maxcut_sdp|<tuple|23|14>>
    <associate|bib-mike_and_ike|<tuple|30|15>>
    <associate|bib-mmw_sdp|<tuple|6|14>>
    <associate|bib-mwa|<tuple|5|14>>
    <associate|bib-qaoa|<tuple|19|14>>
    <associate|bib-qc_adiabat|<tuple|20|14>>
    <associate|bib-qcintro|<tuple|35|15>>
    <associate|bib-qml|<tuple|28|14>>
    <associate|bib-qml_rtfp|<tuple|1|14>>
    <associate|bib-qsdp|<tuple|13|14>>
    <associate|bib-qsdp2|<tuple|12|14>>
    <associate|bib-qwalk_graphs|<tuple|2|14>>
    <associate|bib-revcomp|<tuple|8|14>>
    <associate|bib-solovay_kitaev_algorithm|<tuple|18|14>>
    <associate|bib-van_Apeldoorn_2020|<tuple|33|15>>
    <associate|bra_ket|<tuple|2.3|4>>
    <associate|ckt_diags|<tuple|1|3>>
    <associate|density_operator|<tuple|A|15>>
    <associate|hamiltonian_simulation|<tuple|3.3|6>>
    <associate|mmw_sdp|<tuple|3|12>>
    <associate|quantum_random_walks|<tuple|B|16>>
    <associate|qubit_gates|<tuple|2.2.2|3>>
    <associate|qwalk_plots|<tuple|2|16>>
    <associate|section_adiabat|<tuple|4|7>>
    <associate|section_ampl|<tuple|3.1|5>>
    <associate|section_hhl|<tuple|5|8>>
    <associate|section_qcintro|<tuple|2|1>>
    <associate|section_qctools|<tuple|3|5>>
    <associate|section_qpe|<tuple|3.2|6>>
    <associate|section_sdp|<tuple|6|9>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|bib>
      axler

      qcintro

      mike_and_ike

      heat

      solovay_kitaev_algorithm

      revcomp

      Grover_1998

      Brassard_2002

      mike_and_ike

      mike_and_ike

      Berry_2006

      Childs_2009

      qc_adiabat

      qc_adiabat

      qc_adiabat

      Lucas_2014

      adeqstd

      qaoa

      Peruzzo_2014

      Harrow_2009

      Berry_2006

      Childs_2009

      Berry_2014_diffeq

      qml

      Wiebe_2012

      qml_rtfp

      qml_rtfp

      fastlinsolv

      Childs_2017

      maxcut_sdp

      Boyd2004-hu

      mwa

      mmw_sdp

      qsdp

      mwa

      mwa

      adaboost

      adaboost

      mwa

      mwa

      mmw_sdp

      mmw_sdp

      qsdp

      qsdp

      Temme_2011

      Yung_2012

      mmw_sdp

      qsdp2

      van_Apeldoorn_2020

      mike_and_ike

      Kempe_2003

      qwalk_graphs

      Kempe_2003

      Kempe_2003

      Farhi_1998

      Childs_2002

      Kempe_2003
    </associate>
    <\associate|figure>
      <tuple|normal|<\surround|<hidden-binding|<tuple>|1>|>
        \;
      </surround>|<pageref|auto-7>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|2>|>
        Simulations of the discrete quantum random walk
      </surround>|<pageref|auto-32>>
    </associate>
    <\associate|toc>
      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|1<space|2spc>Introduction>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-1><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|2<space|2spc>A
      crash course in quantum computing >
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-2><vspace|0.5fn>

      <with|par-left|<quote|1tab>|2.1<space|2spc>Postulates
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-3>>

      <with|par-left|<quote|1tab>|2.2<space|2spc>The quantum gate model
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-4>>

      <with|par-left|<quote|2tab>|2.2.1<space|2spc>Composite states
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-5>>

      <with|par-left|<quote|2tab>|2.2.2<space|2spc>Qubit gates
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-6>>

      <with|par-left|<quote|2tab>|2.2.3<space|2spc>Measurement
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-8>>

      <with|par-left|<quote|1tab>|2.3<space|2spc>The bra-ket notation
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-9>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|3<space|2spc>Some
      standard quantum algorithms> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-10><vspace|0.5fn>

      <with|par-left|<quote|1tab>|3.1<space|2spc>Amplitude amplification
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-11>>

      <with|par-left|<quote|1tab>|3.2<space|2spc>Phase estimation
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-12>>

      <with|par-left|<quote|1tab>|3.3<space|2spc>Hamiltonian simulation
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-13>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|4<space|2spc>Adiabatic
      quantum computation> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-14><vspace|0.5fn>

      <with|par-left|<quote|1tab>|4.1<space|2spc>The quantum adiabatic
      algorithm <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-15>>

      <with|par-left|<quote|1tab>|4.2<space|2spc>The Ising model, and
      quadratic binary optimization <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-16>>

      <with|par-left|<quote|1tab>|4.3<space|2spc>A variational approximation
      algorithm <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-17>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|5<space|2spc>The
      HHL algorithm for solving linear systems>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-18><vspace|0.5fn>

      <with|par-left|<quote|1tab>|5.1<space|2spc>The algorithm
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-19>>

      <with|par-left|<quote|1tab>|5.2<space|2spc>Applications and limitations
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-20>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|6<space|2spc>Semidefinite
      programming> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-21><vspace|0.5fn>

      <with|par-left|<quote|1tab>|6.1<space|2spc>The multiplicative weights
      algorithm <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-22>>

      <with|par-left|<quote|1tab>|6.2<space|2spc>Multiplicative weights as
      constructive LP duals <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-23>>

      <with|par-left|<quote|1tab>|6.3<space|2spc>The matrix multiplicative
      weights algorithm <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-24>>

      <with|par-left|<quote|1tab>|6.4<space|2spc>A fast approximate
      primal-dual algorithm for SDPs <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-25>>

      <with|par-left|<quote|1tab>|6.5<space|2spc>A quantum algorithm for
      solving SDPs <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-26>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|7<space|2spc>Summary>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-27><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|Bibliography>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-28><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|Appendix
      A<space|2spc>Density operators> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-29><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|Appendix
      B<space|2spc>Quantum random walks >
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-30><vspace|0.5fn>

      <with|par-left|<quote|1tab>|B.1<space|2spc>A discrete quantum random
      walk <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-31>>

      <with|par-left|<quote|1tab>|B.2<space|2spc>Continuous time random walks
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-33>>
    </associate>
  </collection>
</auxiliary>