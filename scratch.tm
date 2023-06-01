<TeXmacs|2.1>

<style|article>

<\body>
  <doc-data|<doc-title|Quantum algorithms for
  optimization>|<doc-author|<author-data|<author-name|Sumeet
  Shirgure>|<\author-affiliation>
    USC, Spring 2022
  </author-affiliation>>>>

  <abstract-data|<abstract|This term paper documents and discusses some
  recent developments in the advantage gained from using quantum algorithms
  in solving combinatorial and optimization problems.>>

  <section|Introduction>

  In recent years there has been considerable progress in quantum computing
  theory as well as technology. An interesting sub-field of applications of
  quantum algorithms is in solving optimization problems faster than
  classically possible. However, since the information used by such
  algorithms is quantum in nature, we must also be aware of their utility and
  limitations.

  This paper attempts to discuss these topics at a high level without going
  too deep into the technical details, and is supposed to be accessible to
  anyone without a thorough background in quantum computing. Section
  <reference|section_qcintro> gives a bare minimum introduction to quantum
  mechanics and quantum computation, and only requires a working knowledge of
  linear algebra. Section <reference|section_qctools> introduces some
  standard tools in quantum computing. And the later sections each discuss a
  relevent topic in adequate detail.

  <section|A crash course in quantum computing ><label|section_qcintro>

  A short introduction to quantum computing is <cite|qcintro>. Here we review
  some basic concepts at the bare minimum, which are discussed in any text
  <cite|mike_and_ike> on the subject. We will start by reviewing three basic
  postulates of quantum mechanics \U (a) state description, (b) state
  collapse and measurement statistics, and (c) evolution.

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
  <math|<around*|\||0|\<rangle\>><infix-and><around*|\||1|\<rangle\>>> being
  a basis of <math|\<bbb-C\><rsup|2>> are also called the
  <with|font-shape|italic|computational basis> states. When parametrizing the
  qubit state by <math|e<rsup|i\<gamma\>><around*|(|cos<around*|(|\<theta\>|)><around|\||0|\<rangle\>>+e<rsup|i\<varphi\>>sin<around*|(|\<theta\>|)><around*|\||1|\<rangle\>>|)>>,
  we can ignore <math|\<gamma\>>, called the global phase, as we will see it
  has no <with|font-shape|italic|observable effects>.

  Physical quantities of interest like position, momenta, energy, spin are
  are represented by <with|font-shape|italic|observables>, which are linear
  operators acting on <math|\<cal-H\>>. An important example is the energy
  operator <math|<wide|H|^>> - the Hamiltonian. A fundamental idea in quantum
  mechanics is that the eigenvalues of any observable correspond to
  physically observed quantities. Since these must be real even for complex
  vector states, the observables are always Hermitian, i.e they must have
  real eigenvalues : <math|<wide|H|^><rsup|\<dagger\>>=<wide|H|^>>.

  This possibility of a discrete nature of energy eigenvalues is at the heart
  of quantum mechanics.

  The eigenvectors corresponding to an operator are called its
  <with|font-shape|italic|eigenstates>. If a quantum system
  <math|<around*|\||\<psi\>|\<rangle\>>> is in a linear combination of
  eigenstates <math|<big|sum><rsub|j>\<alpha\><rsub|j><around*|\||\<psi\><rsub|j>|\<rangle\>>>,
  it's said to be in a <with|font-shape|italic|quantum superposition> of
  those states. When observed, such a state is postulated to
  <with|font-shape|italic|collapse> to one of the eigenstates
  <math|<around*|\||\<psi\><rsub|j>|\<rangle\>>>. The probability of
  observing energy <math|m> is given by the Born rule :
  <math|<around*|\||\<alpha\><rsub|m>|\|><rsup|2>/<big|sum><rsub|j><around*|\||\<alpha\><rsub|j>|\|><rsup|2>>.
  That is, the probabilities are proportional to the magnitudes of the
  corresponding <with|font-shape|italic|amplitudes> <math|\<alpha\><rsub|j>>.
  This is why the global phases are unobservable. The state
  <math|<around*|\||\<psi\><rsub|j>|\<rangle\>>> after the collapse is again
  normalized.

  E.g the qubit state <math|\<alpha\><rsub|0><around*|\||0|\<rangle\>>+\<alpha\><rsub|1><around*|\||1|\<rangle\>>>
  when measured in the computational basis is put in the state
  <math|<around*|\||j|\<rangle\>>> after measurement with probability
  <math|<around*|\||\<alpha\><rsub|j>|\|><rsup|2>>, and we observe <math|j>
  as some physical phenomenon.

  Finally, the continuous time evolution of a closed quantum system is
  described by the <math|Schr<math|<wide|o|\<ddot\>>>dinger> equation <math|i
  \<hbar\><frac|d|d t><around*|\||\<psi\><around*|(|t|)>|\<rangle\>>=<wide|H|^><around*|\||\<psi\><around*|(|t|)>|\<rangle\>>>,
  <math|<wide|H|^>> being the energy operator.
  <math|\<Rightarrow\><around*|\||\<psi\><around*|(|t|)>|\<rangle\>>=e<rsup|-i
  <wide|H|^>t/\<hbar\>><around*|\||\<psi\><around*|(|0|)>|\<rangle\>>>, where
  the exponentiation is the usual analytic function of the operator
  <math|<wide|H|^>>. The Hamiltonian is <with|font-shape|italic|time-independent>
  since closed systems have conserved energy.

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
  consider thermodynamically isolated closed systems \U a consequence of
  Landauer's principle <cite|heat>.

  <subsection|Quantum computing>

  The standard model of quantum computation is described in terms of a series
  of <with|font-shape|italic|quantum logic gates> applied on a set of qubits.
  Each gate acts on a small subset of qubits. First, we must understand how
  to express composite states with multiple qubits.

  <subsubsection|Composite states>

  The main idea is to take Kronecker products of the corresponding Hilbert
  spaces. The composite state is then the tensor product of the two states.
  E.g if two qubits are in states <math|<matrix|<tformat|<table|<row|<cell|\<alpha\>>>|<row|<cell|\<beta\>>>>>>=\<alpha\><around*|\||0|\<rangle\>>+\<beta\><around*|\||1|\<rangle\>>>
  and <math|<matrix|<tformat|<table|<row|<cell|\<mu\>>>|<row|<cell|\<nu\>>>>>>=\<mu\><around*|\||0|\<rangle\>>+\<nu\><around*|\||1|\<rangle\>>>,
  the composite system is in the state <math|<matrix|<tformat|<table|<row|<cell|\<alpha\>>>|<row|<cell|\<beta\>>>>>>\<otimes\><matrix|<tformat|<table|<row|<cell|\<mu\>>>|<row|<cell|\<nu\>>>>>>=<matrix|<tformat|<table|<row|<cell|\<alpha\>\<mu\>>>|<row|<cell|\<alpha\>\<nu\>>>|<row|<cell|\<beta\>\<mu\>>>|<row|<cell|\<beta\>\<nu\>>>>>>=<around*|(|\<alpha\><around*|\||0|\<rangle\>>+\<beta\><around*|\||1|\<rangle\>>|)>\<otimes\><around*|(|\<mu\><around*|\||0|\<rangle\>>+\<nu\><around*|\||1|\<rangle\>>|)>=\<alpha\>\<mu\><around*|\||0|\<rangle\>>\<otimes\><around*|\||0|\<rangle\>>+\<alpha\>\<nu\><around*|\||0|\<rangle\>>\<otimes\><around*|\||1|\<rangle\>>+\<beta\>\<mu\><around*|\||1|\<rangle\>>\<otimes\><around*|\||0|\<rangle\>>+\<beta\>\<nu\><around*|\||1|\<rangle\>>\<otimes\><around*|\||1|\<rangle\>>>.
  <math|<around*|\||j|\<rangle\>>\<otimes\><around*|\||k|\<rangle\>>> is
  abbreviated as <math|<around*|\||j k|\<rangle\>>>. Hence, sequences of
  qubits in computational basis can be represented as bitstrings inside a ket
  <math|<around*|\|||\<rangle\>>>. The above state is written in the
  <math|<around*|\||00|\<rangle\>>,<around*|\||01|\<rangle\>>,<around*|\||10|\<rangle\>>,<around*|\||11|\<rangle\>>>
  basis of the product Hilbert space <math|\<bbb-C\><rsup|2<rsup|2>>>. Hence,
  <math|n> qubits have <math|\<bbb-C\><rsup|2<rsup|n>>> dimensional states.
  This apparent complexity is not entirely observable, however. But quantum
  computers can process information by moving around in such large spaces.

  Yet another interesting phenomonon is that of
  <with|font-shape|italic|entangled states>. Note that states like
  <math|<around*|\||+|\<rangle\>>=<frac|<around*|\||00|\<rangle\>>+<around*|\||11|\<rangle\>>|<sqrt|2>>>
  can't be expressed as the tensor product of two states. Such entangled
  states are physically realizable, and imply that measuring one qubit will
  immediately tell us about the state of the other. Even if this state itself
  is not a product of two single-qubit states, it does lie in the product
  Hilbert space of the two qubits, which is what the postulate requires.

  Measuring the first qubit of <math|<big|sum><rsub|p q>\<alpha\><rsub|p
  q><around*|\||p q|\<rangle\>>> results in an observation corresponding to
  the <math|<around*|\||0|\<rangle\>>> state, the final state is
  <math|<frac|<big|sum><rsub|q>\<alpha\><rsub|0 q><around*|\||0
  q|\<rangle\>>|<big|sum><rsub|q><around*|\||\<alpha\><rsub|0>q|\|><rsup|2>>>.
  The probability of this happening is itself
  <math|<big|sum><rsub|q><around*|\||\<alpha\><rsub|0q>|\|><rsup|2>>.

  <subsubsection|Qubit gates>

  As noted earlier, qubit evolution must be unitary to keep the state
  normalized. The states of qubits are manipulated using quantum gates that
  are unitary operators acting on corresponding Hilbert spaces. E.g, the NOT
  gate <math|X=<matrix|<tformat|<table|<row|<cell|0>|<cell|1>>|<row|<cell|1>|<cell|0>>>>>>
  maps <math|\<alpha\><around*|\||0|\<rangle\>>+\<beta\><around*|\||1|\<rangle\>>>
  to <math|\<beta\><around*|\||0|\<rangle\>>+\<alpha\><around*|\||1|\<rangle\>>>
  by matrix multiplication, effectively acting as a negation. Any
  <math|2\<times\>2> unitary matrix <math|U> acts on a qubit in state
  <math|<around*|\||\<psi\>|\<rangle\>>> to
  <math|U<around*|\||\<psi\>|\<rangle\>>>.

  Multiple single-qubit gates <math|U<rsub|i>,U<rsub|j>> acting on
  <math|<around*|\||\<varphi\>|\<rangle\>>,<around*|\||\<psi\>|\<rangle\>>>
  is equivalent to <math|U<rsub|i>\<otimes\>U<rsub|j>> acting on
  <math|<around*|\||\<varphi\>|\<rangle\>>\<otimes\><around*|\||\<psi\>|\<rangle\>>>
  : <math|U<rsub|i>\<otimes\>U<rsub|j><around*|(|<around*|\||\<varphi\>|\<rangle\>>\<otimes\><around*|\||\<psi\>|\<rangle\>>|)>=<around*|(|U<rsub|i><around*|\||\<varphi\>|\<rangle\>>|)>\<otimes\><around*|(|U<rsub|j><around*|\||\<psi\>|\<rangle\>>|)>>.
  More generally, a single unitary operation <math|U> can act on multiple
  qubits. E.g, the controlled-NOT, or <math|CNOT=<matrix|<tformat|<table|<row|<cell|1>|<cell|0>|<cell|0>|<cell|0>>|<row|<cell|0>|<cell|1>|<cell|0>|<cell|0>>|<row|<cell|0>|<cell|0>|<cell|0>|<cell|1>>|<row|<cell|0>|<cell|0>|<cell|1>|<cell|0>>>>>>
  which maps <math|<around*|\||p|\<rangle\>>\<otimes\><around*|\||q|\<rangle\>>\<rightarrow\><around*|\||p|\<rangle\>>\<otimes\><around*|\||q\<oplus\>p|\<rangle\>>>
  where <math|\<oplus\>> is bitwise exclusive or. Note how it's convenient to
  just talk of the action of quantum gates on basis states, because linearity
  uniquely extends the definition to superposition states.

  The set of all single qubit unitaries along with CNOT is a universal gate
  set. And even if the number of unitary transformations is uncountably
  infinite, there always exist modest-sized finite gate sequences that
  approximate any desired operation up to an acceptable error in the operator
  norm \U a fact known as the Solovay-Kitaev theorem
  <cite|solovay_kitaev_algorithm>.

  Quantum gates are a generalization of classical gates. However, classical
  gates like AND and OR destroy information irreversibly. Their quantum
  analogs can be implemented using reversible gates like the Toffoli gate
  <math|C C X<around*|\||x|\<rangle\>>*\<otimes\><around*|\||y|\<rangle\>>*\<otimes\><around*|\||z|\<rangle\>>*\<rightarrow\><around*|\||x|\<rangle\>>*\<otimes\><around*|\||y|\<rangle\>>*\<otimes\><around*|\||z\<oplus\><around*|(|x\<wedge\>y|)>|\<rangle\>>>.
  <cite|revcomp> shows that any classical computation can be made reversible
  like this, with a polynomial overhead in the number of qubits and gates.

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
    <label|ckt_diags>
  </big-figure>

  \;

  Like the CNOT gate, we may condition any unitary on the state of an
  external qubit, depicted diagramatically as in figure
  <reference|ckt_diags>(a). <math|<around*|\||c|\<rangle\>>\<oplus\><around*|\||x|\<rangle\>>\<longrightarrow\><around*|\||c|\<rangle\>>\<oplus\>U<rsup|c><around*|\||x|\<rangle\>>>;
  <math|U> is applied only when the control qubit is
  <math|<around*|\||1|\<rangle\>>>. The equivalent unitary is
  <math|<around*|(|<around*|\||0|\<rangle\>><around|\<langle\>|0|\|>\<otimes\>I+<around|\||1|\<rangle\>><around|\<langle\>|1|\|>\<otimes\>U|)>>
  (see section <reference|bra_ket>). Controlled unitaries can hence be
  extended to arbitrary circuits being conditioned on another qubit. Physical
  implementation of controlled unitaries is an issue we won't be concerned
  with.

  Any computable <math|n> bit binary function
  <math|f:\<bbb-Z\><rsub|2><rsup|n>\<rightarrow\>\<bbb-Z\><rsub|2>> can be
  implemented as a unitary operation <math|U<rsub|f>> (figure
  <reference|ckt_diags>(b)) acting on <math|n+1> qubits that acts as
  <math|U<rsub|f><around*|\||x|\<rangle\>>\<otimes\><around|\||y|\<rangle\>>\<longrightarrow\><around*|\||x|\<rangle\>>\<otimes\><around*|\||y\<oplus\>f<around*|(|x|)>|\<rangle\>>>.
  Applying <math|U<rsub|f>> to <math|<around*|\||x|\<rangle\>>\<oplus\><around*|\||0|\<rangle\>>>
  gives us <math|<around*|\||x|\<rangle\>>\<oplus\><around*|\||f<around*|(|x|)>|\<rangle\>>>.
  <math|U<rsub|f>> may require additional qubits as temporary memory, but we
  can always return that temporary memory to its original state by
  <with|font-shape|italic|uncomputing> the intermediate garbage.

  Consider the effect of <math|U<rsub|f>> on
  <math|2<rsup|-n/2><big|sum><rsub|x\<in\>\<bbb-Z\><rsub|2><rsup|n>><around*|\||x|\<rangle\>>\<oplus\><around*|\||0|\<rangle\>>\<longrightarrow\>><space|1em><math|2<rsup|-n/2><big|sum><rsub|x\<in\>\<bbb-Z\><rsub|2><rsup|n>><around*|\||x|\<rangle\>>\<oplus\><around*|\||f<around*|(|x|)>|\<rangle\>>>.
  The physical apparatus implementing <math|U<rsub|f>> must somehow
  simultaneously evaluate <math|f> at every point. And yet, we cannot access
  more than one function output without measuring the output state more than
  once. Even still, such <with|font-shape|italic|quantum parallelism> is
  useful for designing quantum algorithms.

  <subsubsection|Measurement>

  As noted earlier, measurement of a qubit collapses its state into a
  <math|<around*|\||0|\<rangle\>>> or a <math|<around*|\||1|\<rangle\>>>,
  which we can observe as a classical bit. Since measurement is non-unitary,
  it can be used theoretically to affect non-unitary transformations that we
  might need. E.g consider the state <math|<around*|\||\<psi\>|\<rangle\>>=<frac|<around*|\||00|\<rangle\>>+<around*|\||01|\<rangle\>>+<around*|\||10|\<rangle\>>|<sqrt|3>>>.
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

  <subsection|Bra-ket notation><label|bra_ket>

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

  The <math|x> inside <math|<around*|\||x|\<rangle\>>> can be any label as
  per our convenience. Usually the labels name an orthonormal basis spanning
  a Hilbert space.

  Bra-ket notations are also useful to describe operators as sums of outer
  products.

  E.g if a unitary <math|U> maps an orthonormal basis <math|e> to another
  <math|e<rprime|'>> as <math|U<around*|\||e<rsub|j>|\<rangle\>>\<rightarrow\>e<rsup|i\<varphi\><rsub|j>><around*|\||e<rsub|j><rprime|'>|\<rangle\>>>,
  then <math|U> must be <math|<big|sum><rsub|j>e<rsup|i\<varphi\><rsub|j>><around*|\||e<rsub|j><rprime|'>|\<rangle\>><around|\<langle\>|e<rsub|j>|\|>>.
  Indeed <math|U<around*|\||e<rsub|k>|\<rangle\>>=<around*|(|<big|sum><rsub|j>e<rsup|i\<varphi\><rsub|j>><around*|\||e<rsub|j><rprime|'>|\<rangle\>><around|\<langle\>|e<rsub|j>|\|>|)><around*|\||e<rsub|k>|\<rangle\>>=<big|sum><rsub|j>e<rsup|i\<varphi\><rsub|j>><around*|\||e<rsub|j><rprime|'>|\<rangle\>><around|\<langle\>|e<rsub|j><around*|\|||\<nobracket\>>e<rsub|k>|\<rangle\>>=<big|sum><rsub|j>\<delta\><rsub|k
  j>e<rsup|i\<varphi\><rsub|j>><around*|\||e<rsub|j><rprime|'>|\<rangle\>>=e<rsup|i\<varphi\><rsub|k>><around*|\||e<rsub|k><rprime|'>|\<rangle\>>>,
  where <math|<around|\<langle\>|e<rsub|k><around*|\|||\<nobracket\>>e<rsub|j>|\<rangle\>>=\<delta\><rsub|k
  j>> is 1 iff <math|k=j> and is 0 otherwise. As another example, if an
  observable <math|H> has eigenvalues <math|h<rsub|i>> and eigenstates
  <math|<around*|\||u<rsub|i>|\<rangle\>>>, it must be that
  <math|H=<big|sum><rsub|i>h<rsub|i><around*|\||u<rsub|i>|\<rangle\>><around|\<langle\>|u<rsub|i>|\|>>.
  Note that <math|<around*|\||u<rsub|i>|\<rangle\>><around|\<langle\>|u<rsub|i>|\|>>
  is just a projection operator on the <math|i<rsup|th>> eigenvector of
  <math|H>.

  The expected eigenvalue of an observable
  <math|H=<big|sum><rsub|i>h<rsub|i><around|\||u<rsub|i>|\<rangle\>><around|\<langle\>|u<rsub|i>|\|>>
  exhibited by a state <math|<around*|\||\<psi\>|\<rangle\>>> is hence
  <math|<big|sum><rsub|i>h<rsub|i><around*|\||<around|\<langle\>|u<rsub|i><around*|\|||\<nobracket\>>\<psi\>|\<rangle\>>|\|><rsup|2>=<big|sum><rsub|i>h<rsub|i><around|\<langle\>||\<nobracket\>>\<psi\><around*|\||u<rsub|i>|\<rangle\>><around|\<langle\>|u<rsub|i><around*|\|||\<nobracket\>>\<psi\>|\<rangle\>>=<around|\<langle\>|\<psi\><around*|\||<around*|(|<big|sum><rsub|i>h<rsub|i><around|\||u<rsub|i>|\<rangle\>><around|\<langle\>|u<rsub|i>|\|>|)>
  |\|>\<psi\> |\<rangle\>>=<around|\<langle\>|\<psi\><around*|\||H|\|>\<psi\>|\<rangle\>>>,
  where <math|<around|\<langle\>|u<rsub|i><around*|\|||\<nobracket\>>\<psi\>|\<rangle\>>>
  are the projection of <math|\<psi\>> along the eigenstates of <math|H>, and
  the <math|l<rsub|2>>-norm-squares give the probabilities by the Born rule.

  <section|Some standard quantum algorithms><label|section_qctools>

  Here we discuss some common quantum algorithms. These are useful techniques
  for solving combinatorial problems in themselves, and can also be used to
  design more complex ones. This is by no means a complete collection, as it
  skips one of the earliest quantum algorithms \U the quantum Fourier
  transform.

  <subsection|Amplitude amplification><label|section_ampl>

  Also known as Grover's algorithm <cite|Grover_1998>, amplitude
  amplification <cite|amplitude_amplification> is a general technique to
  manipulate superpositions into states having higher amplitudes associated
  with eigenstates we prefer.

  Suppose we are given a unitary oracle <math|U<rsub|f>> for a boolean SAT
  formula <math|f:\<bbb-Z\><rsub|2><rsup|n>\<rightarrow\>\<bbb-Z\><rsub|2>>,
  and we wish to identify some n-bit strings <math|x> satisfying
  <math|f<around*|(|x|)>=1>.

  <math|U<rsub|f>> acts as <math|U<rsub|f><around*|\||x|\<rangle\>>\<otimes\><around*|\||y|\<rangle\>>\<rightarrow\><around*|\||x|\<rangle\>>\<otimes\><around*|\||y\<oplus\>f<around*|(|x|)>|\<rangle\>>>.
  We can convert such an oracle to another <math|U<rsub|w>> that
  \Precognizes\Q feasible strings <math|<around*|\||x|\<rangle\>>> by
  flipping the total phase by <math|-1> :

  <math|<around*|\||x|\<rangle\>>\<otimes\><around*|\||0|\<rangle\>>\<longrightarrow\><around*|[|I\<otimes\>X|]>\<longrightarrow\><around*|\||x|\<rangle\>>\<otimes\><around*|\||1|\<rangle\>>\<longrightarrow\><around*|[|I\<otimes\>H|]>\<longrightarrow\><around*|\||x|\<rangle\>>\<otimes\><around*|(|<frac|<around*|\||0|\<rangle\>>-<around*|\||1|\<rangle\>>|<sqrt|2>>|)>\<longrightarrow\><around*|[|U<rsub|f>|]>\<longrightarrow\>>

  <math|\<longrightarrow\><around*|\||x|\<rangle\>>\<otimes\><around*|(|<frac|<around*|\||f<around*|(|x|)>|\<rangle\>>-<around*|\||1\<oplus\>f<around*|(|x|)>|\<rangle\>>|<sqrt|2>>|)>=<around*|(|-1|)><rsup|f<around*|(|x|)>><around*|\||x|\<rangle\>>\<otimes\><around*|(|<frac|<around*|\||0|\<rangle\>>-<around*|\||1|\<rangle\>>|<sqrt|2>>|)>\<longrightarrow\><around*|[|I\<otimes\><around*|(|X<rsup|-1>
  H<rsup|-1>|)>|]>\<longrightarrow\><around*|(|-1|)><rsup|f<around*|(|x|)>><around*|\||x|\<rangle\>>\<otimes\><around*|\||0|\<rangle\>>>.

  \;

  So <math|U<rsub|w>=<around*|(|I\<otimes\><around*|(|X
  <rsup|-1>H<rsup|-1>|)>|)>U<rsub|f><around*|(|I\<otimes\><around*|(|H
  X|)>|)>> acts as an oracle that recognizes <math|x> with
  <math|f<around*|(|x|)>=1> by negating the phase :
  <math|U<rsub|w><around*|\||x|\<rangle\>><around*|\||0|\<rangle\>>\<rightarrow\><around*|(|-1|)><rsup|f<around*|(|x|)>><around*|\||x|\<rangle\>><around*|\||0|\<rangle\>>>

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
  <math|\<Theta\><around*|(|<sqrt|2<rsup|n>>|)>>. This is what gives us a
  quadratic speedup over exhaustive search. Measuring the resulting state in
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
  transform and QPE. QPE applied on specific unitaries <math|U> directly give
  famous algorithms for factoring and the discrete logarithm problems.

  <subsection|Hamiltonian simulation>

  The earliest motivations of building a quantum computer were the
  realization that a such a device could effeciently simulate quantum
  mechanics, much faster than a classical computer. Chapter 4.7 of
  <cite|mike_and_ike> is an excellent introduction to the topic. Hamiltonian
  simulation is a fundamental part of simulating physical systems.

  Specifically, Hamiltonian simulation is concerned with simulating the
  <math|Schr<math|<wide|o|\<ddot\>>>dinger> equation by approximating the
  operator <math|e<rsup|-i <wide|H|^>t>> via quantum gates. This is hard in
  general, since <math|<wide|H|^>> could be exponentially large.

  Usually, simulation is studied for specific classes of Hamiltonians. E.g
  when <math|<wide|H|^>> is a sum of less complex, more locally acting
  Hamiltonians <math|<big|sum><rsub|k><wide|H<rsub|k>|^>>. The heart of
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

  If the unitary transforms <math|e<rsup|-i <wide|H<rsub|k>|^>\<Delta\>t>>
  can be effeciently implemented as gates, we get an approximation for
  <math|e<rsup|-i<wide|H|^>\<Delta\>t>>. Hamiltonians of the kind
  <math|H=H<rsub|1>\<otimes\>H<rsub|2>\<ldots\>\<otimes\>H<rsub|k>>, also
  sometimes have effecient gate implementations.

  <cite|Berry_2006> gives an algorithm to effeciently simulate sparse
  Hamiltonians \U ones whose matrix have at most <math|s> non-zero elements
  per row/column. Usually algorithms taking sparse matrices as input assume
  an oracle that takes (<math|r>, <math|i>) indices and returns
  <math|i<rsup|th>> non-zero element of the row <math|r> in matrix <math|H>.
  <cite|Childs_2009> discusses discrete and continuous time quantum random
  walks on graphs, and the correspondance of the two cases leads to an
  algorithm for effeciently simulating certain Hamiltonians. Quantum random
  walks are interesting in their own right, and are discussed in appendix
  <reference|quantum_random_walks>.

  <section|The HHL algorithm for solving linear systems><label|section_hhl>

  <cite|Harrow_2009> exhibit a quantum algorithm, from now denoted as the HHL
  algorithm, to solve <math|N\<leqslant\>2<rsup|n>> dimensional linear
  systems of the form <math|A x=b>. We will briefly discuss the overview of
  the algorithm and then go over some its applications/limitations.

  <subsection|The algorithm>

  The HHL algorithm encodes vectors <math|b> and <math|x> by normalizing and
  mapping them to quantum states <math|<around*|\||b|\<rangle\>>> and
  <math|<around*|\||x|\<rangle\>>>. This is done by creating the state
  <math|<around*|\||b|\<rangle\>>=<big|sum><rsub|i\<in\>Z<rsub|2><rsup|n>>b<rsub|i><around*|\||i|\<rangle\>>>,
  i.e the components are stored as amplitudes. If <math|A> is not Hermitian,
  the algorithm works on solving <math|<matrix|<tformat|<table|<row|<cell|0>|<cell|A>>|<row|<cell|A<rsup|\<dagger\>>>|<cell|0>>>>>y=<matrix|<tformat|<table|<row|<cell|b>>|<row|<cell|0>>>>>>
  to obtain <math|<matrix|<tformat|<table|<row|<cell|0>>|<row|<cell|x>>>>>>,
  hence <math|A> is assumed Hermitian from now on. <math|A> therefore has a
  spectral decomposition <math|A=<big|sum><rsub|j>\<lambda\><rsub|j><around*|\||u<rsub|j>|\<rangle\>><around|\<langle\>|u<rsub|j>|\|>>
  with <math|\<lambda\><rsub|j>> as eigenvalues for eigenvectors
  <math|<around*|\||u<rsub|j>|\<rangle\>>>. Rewriting
  <math|<around*|\||b|\<rangle\>>> in that eigenbasis as
  <math|<around*|\||b|\<rangle\>>=<big|sum><rsub|j>\<beta\><rsub|j><around*|\||u<rsub|j>|\<rangle\>>>,
  we have <math|<around*|\||x|\<rangle\>>=A<rsup|-1><around*|\||b|\<rangle\>>=<big|sum><rsub|j>\<lambda\><rsub|j><rsup|-1>\<beta\><rsub|j><around*|\||u<rsub|j>|\<rangle\>>>,
  which is the state HHL computes.

  \;

  To do so, HHL starts with the unitary <math|U=e<rsup|i A
  t>=<big|sum><rsub|j>e<rsup|i \<lambda\><rsub|j>t><around*|\||u<rsub|j>|\<rangle\>><around|\<langle\>|u<rsub|j>|\|>>.
  \ Next, it uses techniques of Hamiltonian simulation from
  <cite|Berry_2006>, <cite|Childs_2009> to implement <math|e<rsup|i A t>>.
  Using quantum phase estimation (section <reference|section_qpe>) with
  <math|U>, it prepares the state <math|<big|sum><rsub|j>\<beta\><rsub|j><around*|\||<wide|\<lambda\><rsub|j>|~>|\<rangle\>><around*|\||u<rsub|j>|\<rangle\>>>
  (Approximately. Since the eigenvalues are not always exact, an in-depth
  analysis takes care of inaccurate phase estimation and its effect on the
  final state, which is expressed as a double sum in the paper.) Here
  <math|<wide|\<lambda\><rsub|j>|~>> is an <math|n-bit> binary approximation
  of <math|\<lambda\><rsub|j>/2\<pi\>>. If <math|\<lambda\><rsub|j>>s are
  large, we scale the entire system so that
  <math|0\<leqslant\>\<lambda\><rsub|j>\<less\>2\<pi\>>.

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
  <math|<wide|O|~><around*|(|log<around*|(|N|)>s<rsup|2>\<kappa\><rsup|3>/\<epsilon\>|)>>.
  An extra factor of <math|\<kappa\>> can be saved by amplitude amplification
  (section <reference|section_ampl>).

  <subsection|Applications and limitations>

  The conception of the HHL algorithm sparked a \Pmini-revolution\Q in the
  field of quantum machine learning. Suddenly, there was renewed interest in
  solving practical problems like least squares fitting, classification and
  clustering using this exponentially faster algorithm.

  As aptly put in <cite|qml_rtfp>, HHL is not
  <with|font-shape|italic|exactly> an algorithm for solving linear equations
  <math|A x=b> in logarithmic time. Rather, it's an algorithm for
  approximately preparing a quantum superposition
  <math|<around*|\||x|\<rangle\>>>. The paper also goes on to discuss its
  limitations, in that HHL guarantees an exponential speedup only when (1)
  the state <math|<around*|\||b|\<rangle\>>> can be loaded quickly in the
  quantum computer's memory, (2) the unitary <math|e<rsup|-i A t>> is
  effeciently implemented as a quantum circuit, and <math|A> is sparse (3)
  <math|A> is <with|font-shape|italic|well-conditioned>, i.e it's condition
  number <math|\<kappa\>=<around*|\||\<lambda\><rsub|max>|\|>/<around*|\||\<lambda\><rsub|min>|\|>>
  is small; note that classical algorithms like the conjugate gradient method
  also prefer well-conditioned matrices (4) Simply writing <math|x> requires
  linear time, however HHL produces <math|<around*|\||x|\<rangle\>>> in
  logarithmically many qubits. The algorithm is useful if we can utilize
  <math|<around*|\||x|\<rangle\>>> and may not be when we definitely need
  <math|x>. <cite|qml_rtfp> further shows that despite these limitations,
  there exist potential applications of HHL.

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

  <section|Adiabatic quantum computation><label|section_adiabat>

  <subsection|The quantum adiabatic algorithm>

  The quantum adiabatic algorithm was first presented in <cite|qc_adiabat>.
  The term <with|font-shape|italic|adiabatic> itself has roots in
  thermodynamics; it refers to processes that don't transfer heat.
  Classically, such reversible processes are also called
  <with|font-shape|italic|isentropic>, in that they don't increase entropy.

  QAA works with <with|font-shape|italic|time-dependent> Hamiltonians
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
  interest, and <math|<wide|H|^><around*|(|t|)>=H<rsub|A><around*|(|1-t/T|)>+t
  H<rsub|B>/T>.

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
  ferromagnetism arising out of interacting spins in nearby atoms in a
  metallic lattice. The configuration of such systems is given by a graph
  <math|G<around*|(|V,E|)>> of spin sites <math|V> and adjacent interacting
  pairs of sites <math|E>. The (classical) Hamiltonian for this graphical
  model takes the form <math|H<around*|(|\<sigma\>|)>=-<big|sum><rsub|<around*|(|i,j|)>\<in\>E>J<rsub|i
  j>\<sigma\><rsub|i>\<sigma\><rsub|j>-\<mu\><big|sum><rsub|i\<in\>V>h<rsub|i>\<sigma\><rsub|i>>,
  where <math|\<sigma\>\<in\><around*|{|+1,-1|}><rsup|<around*|\||V|\|>>>.
  Clearly, for <math|\<mu\>=0>, the cut <math|<around*|{|i:\<sigma\><rsub|i>=+1|}>>
  represents a solution to the weighted max-cut problem. A quantum version of
  such a Hamiltonian, encoding this and other NP-hard problems, is given in
  <cite|Lucas_2014>.

  The class of quadratic unconstrained binary optimizations (QUBO) that seek
  to find <math|argmin<rsub|x\<in\>\<bbb-R\><rsup|n>><around*|{|x<rsup|T>Q
  x|}>>, for symmetric <math|n\<times\>n> matrices
  <math|Q\<in\>\<bbb-S\><rsub|n>> also falls under this paradigm, as they are
  computationally equivalent to the Ising model. Solving this class of
  problems by quantum annealing is one of the main intended uses of some
  adiabatic quantum computers. (One such computer is supposedly right here at
  USC.) Although, quantum annealing is not the same as implementing the
  adiabatic algorithm as mentioned above, the two are closely related.

  It's important to note is that this model of computation is equivalent
  <cite|adeqstd> to the standard gate model discussed earlier. While QAA
  proceeds to solve problems exactly, there do exist families of quantum
  circuits that can approximate a solution. <cite|qaoa> presents an
  approximation scheme (a quantum approximate optimization algorithm, or
  QAOA) that takes a parameter <math|p>, and constructs a circuit with depth
  scaling linearly with <math|p>, and gives increasingly good approximations
  for max-SAT instances.

  \;

  \;

  \;

  \;

  <page-break*>

  <\bibliography|bib|tm-plain|refs>
    <\bib-list|19>
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

      <bibitem*|5><label|bib-revcomp>C.<nbsp>H.<nbsp>Bennett.
      <newblock>Logical reversibility of computation.
      <newblock><with|font-shape|italic|IBM Journal of Research and
      Development>, 17(6):525\U532, 1973.<newblock>

      <bibitem*|6><label|bib-Berry_2006>Dominic<nbsp>W.<nbsp>Berry, Graeme
      Ahokas, Richard Cleve<localize|, and >Barry<nbsp>C.<nbsp>Sanders.
      <newblock>Efficient quantum algorithms for simulating sparse
      hamiltonians. <newblock><with|font-shape|italic|Communications in
      Mathematical Physics>, 270(2):359\U371, dec 2006.<newblock>

      <bibitem*|7><label|bib-amplitude_amplification>G.<nbsp>Brassard<localize|
      and >P.<nbsp>Hoyer. <newblock>An exact quantum polynomial-time
      algorithm for simon's problem. <newblock><localize|In
      ><with|font-shape|italic|Proceedings of the Fifth Israeli Symposium on
      Theory of Computing and Systems>. IEEE Comput. Soc.<newblock>

      <bibitem*|8><label|bib-Childs_2009>Andrew<nbsp>M.<nbsp>Childs.
      <newblock>On the relationship between continuous- and discrete-time
      quantum walk. <newblock><with|font-shape|italic|Communications in
      Mathematical Physics>, 294(2):581\U603, oct 2009.<newblock>

      <bibitem*|9><label|bib-Childs_2017>Andrew<nbsp>M.<nbsp>Childs, Robin
      Kothari<localize|, and >Rolando<nbsp>D.<nbsp>Somma. <newblock>Quantum
      algorithm for systems of linear equations with exponentially improved
      dependence on precision. <newblock><with|font-shape|italic|SIAM Journal
      on Computing>, 46(6):1920\U1950, jan 2017.<newblock>

      <bibitem*|10><label|bib-solovay_kitaev_algorithm>Christopher<nbsp>M.<nbsp>Dawson<localize|
      and >Michael<nbsp>A.<nbsp>Nielsen. <newblock>The solovay-kitaev
      algorithm. <newblock><with|font-shape|italic|Quantum Info. Comput.>,
      6(1):81\U95, jan 2006.<newblock>

      <bibitem*|11><label|bib-qaoa>Edward Farhi, Jeffrey Goldstone<localize|,
      and >Sam Gutmann. <newblock>A quantum approximate optimization
      algorithm. <newblock>2014.<newblock>

      <bibitem*|12><label|bib-qc_adiabat>Edward Farhi, Jeffrey Goldstone, Sam
      Gutmann<localize|, and >Michael Sipser. <newblock>Quantum computation
      by adiabatic evolution. <newblock>2000.<newblock>

      <bibitem*|13><label|bib-Grover_1998>Lov<nbsp>K.<nbsp>Grover.
      <newblock>Quantum computers can search rapidly by using almost any
      transformation. <newblock><with|font-shape|italic|Physical Review
      Letters>, 80(19):4329\U4332, may 1998.<newblock>

      <bibitem*|14><label|bib-Harrow_2009>Aram<nbsp>W.<nbsp>Harrow, Avinatan
      Hassidim<localize|, and >Seth Lloyd. <newblock>Quantum algorithm for
      linear systems of equations. <newblock><with|font-shape|italic|Physical
      Review Letters>, 103(15), oct 2009.<newblock>

      <bibitem*|15><label|bib-Kempe_2003>J Kempe. <newblock>Quantum random
      walks: an introductory overview. <newblock><with|font-shape|italic|Contemporary
      Physics>, 44(4):307\U327, jul 2003.<newblock>

      <bibitem*|16><label|bib-heat>R.<nbsp>Landauer.
      <newblock>Irreversibility and heat generation in the computing process.
      <newblock><with|font-shape|italic|IBM Journal of Research and
      Development>, 5(3):183\U191, 1961.<newblock>

      <bibitem*|17><label|bib-Lucas_2014>Andrew Lucas. <newblock>Ising
      formulations of many NP problems. <newblock><with|font-shape|italic|Frontiers
      in Physics>, 2, 2014.<newblock>

      <bibitem*|18><label|bib-mike_and_ike>Michael<nbsp>A Nielsen<localize|
      and >Isaac<nbsp>L Chuang. <newblock><with|font-shape|italic|Quantum
      Computation and Quantum Information>. <newblock>Cambridge University
      Press, Cambridge, England, dec 2010.<newblock>

      <bibitem*|19><label|bib-qcintro>Noson<nbsp>S.<nbsp>Yanofsky.
      <newblock>An introduction to quantum computing.
      <newblock>2007.<newblock>
    </bib-list>
  </bibliography>

  <appendix|Quantum random walks ><label|quantum_random_walks>

  Random walks are powerful tools when it comes to analysing and designing
  randomized algorithms. Quantum random walks sometimes have an advantage
  over classical random walks. A great introductory survey on this topic is
  <cite|Kempe_2003>.

  Classical random walks are quite invaluable in theoretical CS. They provide
  a general paradigm for sampling from exponentially large spaces. Important
  properties of random walks that affect their usage in algorithms are their
  mixing times and hitting times <cite|qwalk_graphs>. Quantum random walks
  behave quite differently than their classical counterparts in these
  regards, which explains their role in obtaining faster quantum algorithms.

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
  Since <math|S> is a bijection between orthonormal bases, it must be
  unitary. The particle jumps right if its spin is up, and left if down:
  <math|S<around*|(|<around*|\||\<uparrow\>/\<downarrow\>|\<rangle\>>\<otimes\><around*|\||x|\<rangle\>>|)>=<around*|(|<around*|\||\<uparrow\>/\<downarrow\>|\<rangle\>>\<otimes\><around*|\||x\<pm\>1|\<rangle\>>|)>>.

  For a particle in superposition, <math|S> acts linearly, and the resulting
  amplitudes may add or cancel each other. Consider <math|T> alternate
  applications of <math|S> and <math|C> applied to an initial state
  <math|<around*|\||\<downarrow\>|\<rangle\>>>; measuring the position after
  each time step collapses the state to a definite displacement <math|x>. The
  resulting behaviour is identical to a classical random walk with the
  resulting statistics resmbling the Gaussian approximation of binomial
  coeffecients. For large <math|T> the variance
  <math|\<sigma\><rsup|2>\<sim\>T>, while the mean is 0.

  However, if we don't measure the position at every step, the interferences
  over all possible paths at <math|T> steps produce a probability
  distribution over <math|\<bbb-Z\>> that can be skewed, and can even have
  bimodal distributions. The distribution in figure <reference|qwalk_plots>
  (a) is a result of <math|<around*|(|S C|)><rsup|T><around*|(|<around*|\||\<downarrow\>|\<rangle\>>\<otimes\><around*|\||0|\<rangle\>>|)>>.
  <math|C> is asymmetric, and prefers <math|<around*|\||\<downarrow\>|\<rangle\>>>.
  Figure <reference|qwalk_plots> (b) shows the symmteric results of
  <math|<around*|(|S C|)><rsup|T><around*|(|<around*|(|<frac|<around*|\||\<uparrow\>|\<rangle\>>+i<around*|\||\<downarrow\>|\<rangle\>>|<sqrt|2>>|)>\<otimes\><around*|\||0|\<rangle\>>|)>>.
  It can be shown that the quantum walk has a variance that scales as
  <math|\<sigma\><rsup|2>\<sim\>T<rsup|2>>.

  <\big-figure>
    <image|qrandwalk.png|200pt|200pt||><image|qsymwalk.png|200pt|200pt||>

    (a) An asymmetric quantum walk<space|4em>(b) A symmetric walk.
  <|big-figure>
    Simulations of the discrete quantum random walk<label|qwalk_plots>
  </big-figure>
</body>

<\initial>
  <\collection>
    <associate|font-base-size|12>
    <associate|page-medium|paper>
  </collection>
</initial>

<\references>
  <\collection>
    <associate|auto-1|<tuple|1|1>>
    <associate|auto-10|<tuple|3|5>>
    <associate|auto-11|<tuple|3.1|6>>
    <associate|auto-12|<tuple|3.2|7>>
    <associate|auto-13|<tuple|3.3|7>>
    <associate|auto-14|<tuple|4|8>>
    <associate|auto-15|<tuple|4.1|8>>
    <associate|auto-16|<tuple|4.2|8>>
    <associate|auto-17|<tuple|5|9>>
    <associate|auto-18|<tuple|5.1|9>>
    <associate|auto-19|<tuple|5.2|10>>
    <associate|auto-2|<tuple|2|1>>
    <associate|auto-20|<tuple|5.2|11>>
    <associate|auto-21|<tuple|A|11>>
    <associate|auto-22|<tuple|A.1|12>>
    <associate|auto-23|<tuple|2|12>>
    <associate|auto-3|<tuple|2.1|1>>
    <associate|auto-4|<tuple|2.2|2>>
    <associate|auto-5|<tuple|2.2.1|3>>
    <associate|auto-6|<tuple|2.2.2|3>>
    <associate|auto-7|<tuple|1|4>>
    <associate|auto-8|<tuple|2.2.3|5>>
    <associate|auto-9|<tuple|2.3|5>>
    <associate|bib-Berry_2006|<tuple|6|11>>
    <associate|bib-Childs_2009|<tuple|8|11>>
    <associate|bib-Childs_2017|<tuple|9|11>>
    <associate|bib-Grover_1998|<tuple|13|11>>
    <associate|bib-Harrow_2009|<tuple|14|11>>
    <associate|bib-Kempe_2003|<tuple|15|11>>
    <associate|bib-Lucas_2014|<tuple|17|11>>
    <associate|bib-adeqstd|<tuple|3|11>>
    <associate|bib-amplitude_amplification|<tuple|7|11>>
    <associate|bib-fastlinsolv|<tuple|4|11>>
    <associate|bib-heat|<tuple|16|11>>
    <associate|bib-mike_and_ike|<tuple|18|11>>
    <associate|bib-qaoa|<tuple|11|11>>
    <associate|bib-qc_adiabat|<tuple|12|11>>
    <associate|bib-qcintro|<tuple|19|11>>
    <associate|bib-qml_rtfp|<tuple|1|11>>
    <associate|bib-qwalk_graphs|<tuple|2|11>>
    <associate|bib-revcomp|<tuple|5|11>>
    <associate|bib-solovay_kitaev_algorithm|<tuple|10|11>>
    <associate|bra_ket|<tuple|2.3|5>>
    <associate|ckt_diags|<tuple|1|4>>
    <associate|quantum_random_walks|<tuple|A|11>>
    <associate|qwalk_plots|<tuple|2|12>>
    <associate|section_adiabat|<tuple|5|9>>
    <associate|section_ampl|<tuple|3.1|6>>
    <associate|section_hhl|<tuple|4|8>>
    <associate|section_qcintro|<tuple|2|1>>
    <associate|section_qctools|<tuple|3|5>>
    <associate|section_qpe|<tuple|3.2|7>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|bib>
      qcintro

      mike_and_ike

      heat

      solovay_kitaev_algorithm

      revcomp

      Grover_1998

      amplitude_amplification

      mike_and_ike

      mike_and_ike

      Berry_2006

      Childs_2009

      Harrow_2009

      Berry_2006

      Childs_2009

      qml_rtfp

      qml_rtfp

      fastlinsolv

      Childs_2017

      qc_adiabat

      qc_adiabat

      qc_adiabat

      Lucas_2014

      adeqstd

      qaoa

      Kempe_2003

      qwalk_graphs
    </associate>
    <\associate|figure>
      <tuple|normal|<\surround|<hidden-binding|<tuple>|1>|>
        \;
      </surround>|<pageref|auto-7>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|2>|>
        Simulations of the discrete quantum random walk
      </surround>|<pageref|auto-23>>
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

      <with|par-left|<quote|1tab>|2.2<space|2spc>Quantum computing
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

      <with|par-left|<quote|1tab>|2.3<space|2spc>Bra-ket notation
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

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|4<space|2spc>The
      HHL algorithm for solving linear systems>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-14><vspace|0.5fn>

      <with|par-left|<quote|1tab>|4.1<space|2spc>The algorithm
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-15>>

      <with|par-left|<quote|1tab>|4.2<space|2spc>Applications and limitations
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-16>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|5<space|2spc>Adiabatic
      quantum computation> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-17><vspace|0.5fn>

      <with|par-left|<quote|1tab>|5.1<space|2spc>The quantum adiabatic
      algorithm <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-18>>

      <with|par-left|<quote|1tab>|5.2<space|2spc>The Ising model, and
      quadratic binary optimization <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-19>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|Bibliography>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-20><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|Appendix
      A<space|2spc>Quantum random walks >
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-21><vspace|0.5fn>

      <with|par-left|<quote|1tab>|A.1<space|2spc>A discrete quantum random
      walk <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-22>>
    </associate>
  </collection>
</auxiliary>