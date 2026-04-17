import OmegaTheory.Irrationality.Uncertainty
namespace OmegaTheory.Probe
open OmegaTheory.Irrationality
theorem agent_test_pi_positive (N : ℕ) : 0 < computationalUncertainty N :=
  computationalUncertainty_pos N
end OmegaTheory.Probe
